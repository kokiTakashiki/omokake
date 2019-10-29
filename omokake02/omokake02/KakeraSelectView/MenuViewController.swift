//
//  StartViewController.swift
//  omokake02
//
//  Created by takasiki on 10/13/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    //var partsCount:Int = 0
    let presentor = MenuViewPresentorImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sankakuWatatasu" {
            
            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve
            
            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = 500//presentor.getPhotoCount()
            flowSelectViewController.selectKakera = ["kakera","kakera2"]
            //self.dismiss(animated: true, completion: nil)
        }
        
        if segue.identifier == "SikakuWatatasu" {
            
            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve
            
            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = 500//presentor.getPhotoCount()
            flowSelectViewController.selectKakera = ["kakeraS1","kakeraS2"]
            //self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
