//
//  DoubanVC.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/27.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import ESPullToRefresh
import SnapKit
import Moya

class DoubanViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var page = 0
    var channels:Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "豆瓣"
        
        self.customUI()
        self.requestListData()

    }
    
    
    func customUI() {
        
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .action,
                                                                    target:self,
                                                                    action:#selector(DoubanViewController.downloadFeil)),
                                                    UIBarButtonItem(barButtonSystemItem: .add,
                                                                    target:self,
                                                                    action:#selector(DoubanViewController.downloadFeil1)),],
                                                   animated: true)

//        self.navigationController?.navigationBar.isTranslucent = false
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "SwiftCell")
        self.tableView!.tableFooterView = UIView()
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            // Fallback on earlier versions
        }
        self.tableView!.es.addPullToRefresh {
            [unowned self] in
            /// Do anything you want...
            self.page = 0
            self.requestListData()

        }
        
        self.tableView!.es.addInfiniteScrolling {
            [unowned self] in
            /// Do anything you want...
            self.page += 1
            self.requestListData()
        }
        
    }
    
    ///返回表格分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identify, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            //设置单元格内容
            cell.textLabel?.text = channels[indexPath.row]["name"].stringValue
            return cell
    }
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //获取选中项信息
        let channelName = channels[indexPath.row]["name"].stringValue
        let channelId = channels[indexPath.row]["channel_id"].stringValue
        self.requestDetailData(channelId: channelId, channelName: channelName)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func downloadFeil() {
        //要下载的图片名称
        let assetName = "95eef01f3a292df52ed1255db1315c6034a8736c.jpg"
        //通过Moya进行下载
        MyServiceProvider.request(.downloadAsset(assetName: assetName), progress:{
            progress in
            //实时打印出下载进度
            print("当前进度: \(progress.progress)")
        }) { result in
            switch result {
            case .success:
                let localLocation: URL = DefaultDownloadDir.appendingPathComponent(assetName)
                let image = UIImage(contentsOfFile: localLocation.path)
                print("下载完毕！保存地址：\(localLocation)")
                self.imageView.image = image
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    @objc func downloadFeil1() {
        let loader = AssetLoader()
        loader.load(asset: .logo) { result in
            switch result {
            case let .success(localLocation):
                print("下载完毕！保存地址：\(localLocation)")
                let image = UIImage(contentsOfFile: (localLocation as AnyObject).path)
                self.imageView.image = image
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    
    func requestListData() {
        //使用我们的provider进行网络请求（获取频道列表数据）
        let DouBanProvider = MoyaProvider<DouBan>(plugins: [
            RequestActivityPlugin(view: self.view)
            ])
        DouBanProvider.request(.channels) { result in
            
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                self.channels = json["channels"].arrayValue
                
                //刷新表格数据
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            }else{
                /// If common end
                self.tableView.es.stopLoadingMore()
                /// If no more data
                self.tableView.es.noticeNoMoreData()
            }
        }
    }
    
    
    func requestDetailData(channelId:String?, channelName:String?) {
        guard let channelId = channelId , let channelName = channelName else {
            return
        }
        Network.request(.playlist(channelId), success: { json in
            //获取歌曲信息
            let music = json["song"].arrayValue[0]
            let artist = music["artist"].stringValue
            let title = music["title"].stringValue
            let message = "歌手：\(artist)\n歌曲：\(title)"
            //将歌曲信息弹出显示
            self.showAlert(title: channelName, message: message)
        }, error: { statusCode in
            //服务器报错等问题
            print("请求错误！错误码：\(statusCode)")
        }, failure: { error in
            //没有网络等问题
            print("请求失败！错误信息：\(error.errorDescription ?? "")")
        })
        //        //使用我们的provider进行网络请求（根据频道ID获取下面的歌曲）
        //        DouBanProvider.request(.playlist(channelId)) { result in
        //            switch result {
        //
        //            case let .success(response):
        //                let statusCode = response.statusCode // 响应状态码：200, 401, 500...
        //                let data = try? response.mapJSON()
        //                let json = JSON(data!)
        //                let music = json["song"].arrayValue[0]
        //                let artist = music["artist"].stringValue
        //                let title = music["title"].stringValue
        //                let message = "statusCode : \(statusCode) \n 歌手：\(artist)\n歌曲：\(title)"
        //
        //                //将歌曲信息弹出显示
        //                self.showAlert(title: channelName, message: message)
        //
        //            case let .failure(error):
        //                //错误处理....
        //                switch error {
        //                case .imageMapping(let response):
        //                    print("错误原因：\(error.errorDescription ?? "")")
        //                    print(response)
        //                case .jsonMapping(let response):
        //                    print("错误原因：\(error.errorDescription ?? "")")
        //                    print(response)
        //                case .statusCode(let response):
        //                    print("错误原因：\(error.errorDescription ?? "")")
        //                    print(response)
        //                case .stringMapping(let response):
        //                    print("错误原因：\(error.errorDescription ?? "")")
        //                    print(response)
        //                case .underlying(let error, let response):
        //                    print("错误原因：\(error.errorDescription ?? "")")
        //                    print(error)
        //                    print(response as Any)
        //                case .requestMapping:
        //                    print("错误原因：\(error.errorDescription ?? "")")
        //                    print("nil")
        //                }
        //            }
        //        }
    }
    
    
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


