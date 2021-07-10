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
    @IBOutlet weak var photosCount: UILabel!
    var partsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        partsCount = 100//presentor.getPhotoCount()
        photosCount.text = String(partsCount) + " kakera"
        
//        let thumbnailSize = CGSize(width: 10, height: 10)
//        var originalArray:[UIImage] = []
//        for cell in 0..<partsCount {
//            originalArray = originalArray + presentor.getThumbnail(indexPathRow: cell, thumbnailSize: thumbnailSize)
//            print("配列の数は\(originalArray.count)です")
//        }
    }
    @IBAction func sankakuAction(_ sender: Any) {
//        if partsCount < 200 {
//            let alert: UIAlertController = UIAlertController(title: "写真をもっと撮ってみませんか？", message: "写真の枚数が少ないです。\n満足のいかない作品になる可能性があります。\n推奨は200枚以上です。", preferredStyle:  UIAlertController.Style.alert)
//            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                (action: UIAlertAction!) -> Void in
//                print("OK")
//                let flowSelectViewController = FlowSelectViewController()
//                flowSelectViewController.modalTransitionStyle = .crossDissolve
//                //ここで写真の枚数を送ります。
//                flowSelectViewController.partsCount = self.partsCount
//                flowSelectViewController.selectKakera = ["kakera","kakera2"]
//                // 遷移方法にフルスクリーンを指定
//                flowSelectViewController.modalPresentationStyle = .fullScreen
//                self.present(flowSelectViewController, animated: true, completion: nil)
//            })
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "sankakuWatatasu" {

            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve

            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = partsCount
            flowSelectViewController.selectKakera = ["kakera","kakera2"]
            //self.dismiss(animated: true, completion: nil)
        }

        if segue.identifier == "SikakuWatatasu" {

            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve

            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = partsCount
            flowSelectViewController.selectKakera = ["kakeraS1","kakeraS2"]
            //self.dismiss(animated: true, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
