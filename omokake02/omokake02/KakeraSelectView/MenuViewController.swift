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
    var selectkakera:String = ""
    var isBlendingEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        partsCount = 300001//presentor.getPhotoCount()
        photosCount.text = String(partsCount) + " kakera"
        
//        let thumbnailSize = CGSize(width: 10, height: 10)
//        var originalArray:[UIImage] = []
//        for cell in 0..<partsCount {
//            originalArray = originalArray + presentor.getThumbnail(indexPathRow: cell, thumbnailSize: thumbnailSize)
//            print("配列の数は\(originalArray.count)です")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: IBAction
extension MenuViewController {
    @IBAction func sankakuAction(_ sender: Any) {
        selectkakera = "sankaku"//["kakera","kakera2"]
        isBlendingEnabled = true
        partsAlertAndPresent()
    }
    
    @IBAction func sikakuAction(_ sender: Any) {
        selectkakera = "thumbnail"//["kakeraS1","kakeraS2"]
        isBlendingEnabled = false
        partsAlertAndPresent()
    }
    
    // 6s 100000
    // 11Pro 300000
    private func partsAlertAndPresent() {
        if partsCount < 200 {
            let alert: UIAlertController = UIAlertController(title: "写真をもっと\n撮ってみませんか？", message: "写真の枚数が少ないです。\n満足のいかない作品になる可能性が\nあります。\n推奨は200枚以上です。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                self.performSegue(withIdentifier: "FlowSelectView", sender: nil)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else if partsCount > 300000 {
            let alert: UIAlertController = UIAlertController(title: "あなたは最高の写真家です。", message: "あなたのiPhoneでは300000かけらの生成が\n限界となっています。\nその限界を超えたあなたに特別な機能を\n用意しました。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                self.performSegue(withIdentifier: "FlowSelectView", sender: nil)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "FlowSelectView", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "FlowSelectView" {

            let flowSelectViewController:FlowSelectViewController = segue.destination as! FlowSelectViewController
            flowSelectViewController.modalTransitionStyle = .crossDissolve

            //ここで写真の枚数を送ります。
            flowSelectViewController.partsCount = partsCount
            flowSelectViewController.selectKakera = selectkakera
            flowSelectViewController.isBlendingEnabled = isBlendingEnabled
        }

    }
}
