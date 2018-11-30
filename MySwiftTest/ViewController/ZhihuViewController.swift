//
//  ZhihuViewController.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/30.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import Kingfisher
import HandyJSON

class ZhihuViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var page = 0
    var stories:Array<Story>?
    var topStories:Array<TopStory> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "知乎"
        
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
        return stories?.count ?? 0
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let identify:String = "SwiftCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
//            cell.accessoryType = .disclosureIndicator

            let story = stories![indexPath.row]
            cell.textLabel?.text = story.title
            cell.imageView?.kf.setImage(with: URL(string: (story.images?.first)!))
            return cell
    }
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func requestListData() {
        NetworkRequest(.newsLatest, success: { (result) -> (Void) in
            dPrint(result.type)
            let json = result
            dPrint(json)
            dPrint(json["date"])
            dPrint(json["stories"])
            dPrint(json["top_stories"])
            
            dPrint(json["date"].type)
            dPrint(json["stories"].type)
            dPrint(json["top_stories"].type)
            let arr:[Any]? = json["stories"].array
            self.stories = [Story].deserialize(from: arr) as? Array<Story>
            
////            if let s = json["stories"] as? [ Any] {
//                let stories = [Story].deserialize(from:json["stories"])
//                self.stories = stories! as! Array<Story>
////            }
 
            self.tableView.reloadData()
        }) { (errorCode) -> (Void) in
            
        }
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
