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
        deviceMaxParts(note)
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
    private func deviceMaxParts(_ note: AlbumInfo) {
        let device = Device.current
        print("[MenuViewController] device \(device)")
        switch device {
        case .iPhone6s:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhone6sPlus:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhoneSE:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhone7:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhone8:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhone7Plus:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhoneX:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhone8Plus:
            partsAlertAndPresent(note, maxParts: 200)
        case .iPhoneXR:
            partsAlertAndPresent(note, maxParts: 300)
        case .iPhoneXSMax:
            partsAlertAndPresent(note, maxParts: 300)
        case .iPhoneXS:
            partsAlertAndPresent(note, maxParts: 300)
        case .iPhoneSE2:
            partsAlertAndPresent(note, maxParts: 300)
        case .iPhone11:
            partsAlertAndPresent(note, maxParts: 400)
        case .iPhone11ProMax:
            partsAlertAndPresent(note, maxParts: 400)
        case .iPhone11Pro:
            partsAlertAndPresent(note, maxParts: 400)
        case .iPhone12Pro:
            partsAlertAndPresent(note, maxParts: 400)
        case .iPhone12:
            partsAlertAndPresent(note, maxParts: 400)
        case .iPhone12ProMax:
            partsAlertAndPresent(note, maxParts: 400)
        default:
            partsAlertAndPresent(note, maxParts: 200)
        }
    }
    
    // 6s 200
    // 11Pro 400
    private func partsAlertAndPresent(_ note: AlbumInfo, maxParts: Int) {
        if note.photosCount < 10 {
            let alert: UIAlertController = UIAlertController(title: "写真をもっと\n撮ってみませんか？", message: "写真の枚数が少ないです。\n満足のいかない作品になる可能性が\nあります。\n推奨は10枚以上です。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.present(note)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else if note.photosCount > maxParts {
            // TODO: 現状maxpartで制限かける。次期アップデートでかけら量を自由に変更できる画面を用意する予定。\nその限界を超えたあなたに特別な機能を\n用意しました。
            partsCount = maxParts
            let alert: UIAlertController = UIAlertController(title: "\(maxParts)枚に制限します。", message: "サムネイル表示では\(maxParts)枚の\n表示が上限となっています。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.present(note)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            self.present(note)
        }
    }
    
}
