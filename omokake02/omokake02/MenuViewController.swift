//
//  StartViewController.swift
//  omokake02
//
//  Created by takasiki on 10/13/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

class MenuViewController: UIViewController {
    
    //var partsCount:Int = 0
    @IBOutlet weak var photosCount: UILabel!
    var partsCount = 0
    var selectKakera:String = ""
    var isBlendingEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partsCount = PhotosManager.allPhotoCount()
        photosCount.text = String(partsCount) + " kakera"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: IBAction
extension MenuViewController {
    @IBAction func sankakuAction(_ sender: Any) {
        selectKakera = "sankaku"//["kakera","kakera2"]
        isBlendingEnabled = true
        deviceMaxParts()
    }
    
    @IBAction func sikakuAction(_ sender: Any) {
        selectKakera = "sikaku"//["kakeraS1","kakeraS2"]
        isBlendingEnabled = true
        deviceMaxParts()
    }
    
    @IBAction func thumbnailAction(_ sender: Any) {
        selectKakera = "thumbnail"//["kakeraS1","kakeraS2"]
        isBlendingEnabled = false
        //deviceMaxParts()
        let selectAlbumStoryboard = UIStoryboard(name: "SelectAlbumViewController", bundle: nil)
        let selectAlbumViewController = selectAlbumStoryboard.instantiateViewController(withIdentifier: "SelectAlbumView") as! SelectAlbumViewController
        selectAlbumViewController.partsCount = partsCount
        selectAlbumViewController.selectKakera = selectKakera
        selectAlbumViewController.isBlendingEnabled = isBlendingEnabled
        selectAlbumViewController.modalPresentationStyle = .fullScreen
        self.present(selectAlbumViewController, animated: true, completion: nil)
    }
}

// MARK: praivate
extension MenuViewController {
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://volx.jp/iphone-antutu-benchmark
    private func deviceMaxParts() {
        let device = Device.current
        print("[MenuViewController] device \(device)")
        switch device {
        case .iPhone6s:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhone6sPlus:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhoneSE:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhone7:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhone8:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhone7Plus:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhoneX:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhone8Plus:
            partsAlertAndPresent(maxParts: 100000)
        case .iPhoneXR:
            partsAlertAndPresent(maxParts: 200000)
        case .iPhoneXSMax:
            partsAlertAndPresent(maxParts: 200000)
        case .iPhoneXS:
            partsAlertAndPresent(maxParts: 200000)
        case .iPhoneSE2:
            partsAlertAndPresent(maxParts: 200000)
        case .iPhone11:
            partsAlertAndPresent(maxParts: 300000)
        case .iPhone11ProMax:
            partsAlertAndPresent(maxParts: 300000)
        case .iPhone11Pro:
            partsAlertAndPresent(maxParts: 300000)
        case .iPhone12Pro:
            partsAlertAndPresent(maxParts: 300000)
        case .iPhone12:
            partsAlertAndPresent(maxParts: 300000)
        case .iPhone12ProMax:
            partsAlertAndPresent(maxParts: 300000)
        default:
            partsAlertAndPresent(maxParts: 100000)
        }
    }
    
    // 6s 100000
    // 11Pro 300000
    private func partsAlertAndPresent(maxParts: Int) {
        if partsCount < 200 {
            let alert: UIAlertController = UIAlertController(title: "写真をもっと\n撮ってみませんか？", message: "写真の枚数が少ないです。\n満足のいかない作品になる可能性が\nあります。\n推奨は200枚以上です。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.present()
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else if partsCount > maxParts {
            // TODO: 現状maxpartで制限かける。次期アップデートでかけら量を自由に変更できる画面を用意する予定。\nその限界を超えたあなたに特別な機能を\n用意しました。
            partsCount = maxParts
            let alert: UIAlertController = UIAlertController(title: "あなたは最高の写真家です。", message: "あなたのiPhoneでは\(maxParts)かけらの\n生成が限界となっています。\n\(maxParts)かけらを生成します。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.present()
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            self.present()
        }
    }
    
    private func present() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let drawViewController = mainStoryboard.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
        drawViewController.partsCount = partsCount
        drawViewController.selectKakera = selectKakera
        drawViewController.isBlendingEnabled = isBlendingEnabled
        drawViewController.albumInfo = AlbumInfo(index: 0, title: "", photosCount: 0)
        drawViewController.modalPresentationStyle = .fullScreen
        drawViewController.modalTransitionStyle = .crossDissolve
        self.present(drawViewController, animated: true, completion: nil)
    }
}
