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
        albumData.append(PhotosManager.favoriteAlbumInfo())
        albumData = albumData + PhotosManager.albumTitleNames()
        tableView.item = albumData
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

extension SelectAlbumViewController: AlbumTableViewDelegate {
    func albumTable(_ tableView: AlbumTableView, didSelectNoteListTable note: AlbumInfo) {
        deviceMaxParts(note)
    }
}

extension SelectAlbumViewController {
    @IBAction func backSelectKakeraAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectAlbumViewController {
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://volx.jp/iphone-antutu-benchmark
    private func deviceMaxParts(_ note: AlbumInfo) {
        let device = Device.current
        print("[MenuViewController] device \(device)")
        switch device {
        case .iPhoneXR, .iPhoneXSMax, .iPhoneXS, .iPhoneSE2:
            partsAlertAndPresent(note, maxParts: 300)

        case .iPhone11, .iPhone11ProMax, .iPhone11Pro, .iPhone12Pro, .iPhone12, .iPhone12ProMax:
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
    
//    private func present(_ note: AlbumInfo) {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let drawViewController = mainStoryboard.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
//        drawViewController.partsCount = partsCount
//        drawViewController.selectKakera = selectKakera
//        drawViewController.isBlendingEnabled = isBlendingEnabled
//        drawViewController.albumInfo = note
//        drawViewController.modalPresentationStyle = .fullScreen
//        drawViewController.modalTransitionStyle = .crossDissolve
//        self.present(drawViewController, animated: true, completion: nil)
//    }
    private func present(_ note: AlbumInfo) {
        let partSizeChangeStoryboard = UIStoryboard(name: "PartSizeChangeView", bundle: nil)
        let partSizeChangeViewController = partSizeChangeStoryboard.instantiateViewController(withIdentifier: "PartSizeChangeView") as! PartSizeChangeViewController
        partSizeChangeViewController.partsCount = partsCount
        partSizeChangeViewController.selectKakera = selectKakera
        partSizeChangeViewController.isBlendingEnabled = isBlendingEnabled
        partSizeChangeViewController.albumInfo = note
        partSizeChangeViewController.modalPresentationStyle = .fullScreen
        self.present(partSizeChangeViewController, animated: true, completion: nil)
    }
}
