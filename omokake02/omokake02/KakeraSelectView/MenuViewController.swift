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
        //let partsCount = presentor.getPhotoCount()
        
//        let thumbnailSize = CGSize(width: 10, height: 10)
//        var originalArray:[UIImage] = []
//        for cell in 0..<partsCount {
//            originalArray = originalArray + presentor.getThumbnail(indexPathRow: cell, thumbnailSize: thumbnailSize)
//            print("配列の数は\(originalArray.count)です")
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sankakuWatatasu" {
            
            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve
            
            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = presentor.getPhotoCount()
            flowSelectViewController.selectKakera = ["kakera","kakera2"]
            //self.dismiss(animated: true, completion: nil)
        }
        
        if segue.identifier == "SikakuWatatasu" {
            
            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve
            
            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = presentor.getPhotoCount()
            flowSelectViewController.selectKakera = ["kakeraS1","kakeraS2"]
            //self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
