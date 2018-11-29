//
//  ViewController.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/26.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import UIKit
import Reachability

class ViewController: RootViewController {

    let val = 8000.999
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let name = self.greet(person: "T##String", day: "T##String")
        dPrint(name)
        
        let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
        dPrint(statistics)
        
        dPrint(statistics.sum)
        dPrint(statistics.2)
        
        dPrint(returnFifteen())
        dPrint(sumOf(numbers: 42, 597, 12))
        
        NetWorkRequest(.testApiDict(dict: Dictionary()), completion: { (response) -> (Void) in
            
        }, failed: { (error) -> (Void) in
            
        }) { () -> (Void) in
            
        }
        
    }

    func greet(person: String, day: String) -> String {
        return "Hello \(person), today is \(day)."
    }
    
    func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
        var min = scores[0]
        var max = scores[0]
        var sum = 0
        
        for score in scores {
            if score > max {
                max = score
            } else if score < min {
                min = score
            }
            sum += score
        }
        
        return (min, max, sum)
    }
    
    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for number in numbers {
            sum += number
        }
        return sum
    }
    
    func returnFifteen() -> Int {
        var y = 10
        func add() {
            y += Int(self.val) + 5
        }
        add()
        return y
    }

}

