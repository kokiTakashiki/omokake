//
//  SelectAlbumViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/14.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit
import DeviceKit

class SelectAlbumViewController: UIViewController {
    @IBOutlet weak var tableView: AlbumTableView!
    
    var partsCount:Int = 1
    var selectKakera:String = ""//:Array<String> = ["kakera","kakera2"]
    var isBlendingEnabled:Bool = false
    
    var albumData = [AlbumInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.selectDelegate = self
        albumData = PhotosManager.albumTitleNames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.item = albumData
        tableView.reloadData()
    }
}

extension SelectAlbumViewController: AlbumTableViewDelegate {
    func albumTable(_ tableView: AlbumTableView, didSelectNoteListTable note: AlbumInfo) {
        if note.photosCount > 400 {
            let alert: UIAlertController = UIAlertController(title: "400枚に制限します。", message: "サムネイル表示では400枚が上限となっています。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.present(note)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        present(note)
    }
    
    private func present(_ note: AlbumInfo) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let flowSelectViewController = mainStoryboard.instantiateViewController(withIdentifier: "FlowSelectViewController") as! FlowSelectViewController
        flowSelectViewController.partsCount = partsCount
        flowSelectViewController.selectKakera = selectKakera
        flowSelectViewController.isBlendingEnabled = isBlendingEnabled
        flowSelectViewController.albumInfo = note
        flowSelectViewController.modalPresentationStyle = .fullScreen
        self.present(flowSelectViewController, animated: true, completion: nil)
    }
}

extension SelectAlbumViewController {
    @IBAction func backSelectKakeraAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension SelectAlbumViewController {
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://volx.jp/iphone-antutu-benchmark
    private func deviceMaxParts() {
        let device = Device.current
        print("[MenuViewController] device \(device)")
        switch device {
        case .iPhone6s:
            partsAlertAndPresent(maxParts: 200)
        case .iPhone6sPlus:
            partsAlertAndPresent(maxParts: 200)
        case .iPhoneSE:
            partsAlertAndPresent(maxParts: 200)
        case .iPhone7:
            partsAlertAndPresent(maxParts: 200)
        case .iPhone8:
            partsAlertAndPresent(maxParts: 200)
        case .iPhone7Plus:
            partsAlertAndPresent(maxParts: 200)
        case .iPhoneX:
            partsAlertAndPresent(maxParts: 200)
        case .iPhone8Plus:
            partsAlertAndPresent(maxParts: 200)
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
        if partsCount < 10 {
            let alert: UIAlertController = UIAlertController(title: "写真をもっと\n撮ってみませんか？", message: "写真の枚数が少ないです。\n満足のいかない作品になる可能性が\nあります。\n推奨は10枚以上です。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "FlowSelectView", sender: nil)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else if partsCount > maxParts {
            // TODO: 現状maxpartで制限かける。次期アップデートでかけら量を自由に変更できる画面を用意する予定。\nその限界を超えたあなたに特別な機能を\n用意しました。
            partsCount = maxParts
            let alert: UIAlertController = UIAlertController(title: "あなたは最高の写真家です。", message: "あなたのiPhoneでは\(maxParts)かけらの\n生成が限界となっています。\n\(maxParts)かけらを生成します。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "FlowSelectView", sender: nil)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "FlowSelectView", sender: nil)
        }
    }
    
}
