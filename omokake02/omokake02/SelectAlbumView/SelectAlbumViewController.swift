//
//  SelectAlbumViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/14.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit
import DeviceKit

final class SelectAlbumViewController: UIViewController {
    struct ViewModel {
        var partsCoint: Int
        let selectKakera: String //:Array<String> = ["kakera","kakera2"]
        let isBlendingEnabled: Bool
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(.init(nibName: "AlbumTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "AlbumTableViewCell")
        }
    }
    
    var viewModel: ViewModel?
    var albumData = [AlbumInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TOOD ViewControllerの責務として描画飲みが好ましいので処理はpresenterなどに移動させた方が設計としては綺麗になる
        albumData.append(PhotosManager.favoriteAlbumInfo())
        albumData = albumData + PhotosManager.albumTitleNames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Extension UITableViewDataSource, UITableViewDelegate
extension SelectAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albumData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        cell.setData(title: album.title, photosCount: album.photosCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albumData[indexPath.row]
        deviceMaxParts(album)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Extension SelectAlbumViewController
extension SelectAlbumViewController {
    @IBAction func backSelectKakeraAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Extension Private Method
extension SelectAlbumViewController {
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://volx.jp/iphone-antutu-benchmark
    private func deviceMaxParts(_ note: AlbumInfo) {
        let device = Device.current
        print("[SelectAlbumViewController] deviceMaxParts \(device)")
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
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK",
                                                             style: UIAlertAction.Style.default,
                                                             handler:{ (action: UIAlertAction!) -> Void in
                self.present(note)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)

        } else if note.photosCount > maxParts {
            // TODO: 現状maxpartで制限かける。次期アップデートでかけら量を自由に変更できる画面を用意する予定。\nその限界を超えたあなたに特別な機能を\n用意しました。
            viewModel?.partsCoint = maxParts
            let alert: UIAlertController = UIAlertController(title: "\(maxParts)枚に制限します。",
                                                             message: "サムネイル表示では\(maxParts)枚の\n表示が上限となっています。",
                                                             preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK",
                                                             style: UIAlertAction.Style.default,
                                                             handler:{ (action: UIAlertAction!) -> Void in
                self.present(note)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            self.present(note)
        }
    }
    
    private func present(_ note: AlbumInfo) {
        let partSizeChangeViewController = instantiateStoryBoardToViewController(storyBoardName: "PartSizeChangeView",
                                                                             withIdentifier: "PartSizeChangeView") as! PartSizeChangeViewController
        partSizeChangeViewController.partsCount = viewModel?.partsCoint ?? 1
        partSizeChangeViewController.selectKakera = viewModel?.selectKakera ?? ""
        partSizeChangeViewController.isBlendingEnabled = viewModel?.isBlendingEnabled ?? false
        partSizeChangeViewController.albumInfo = note
        partSizeChangeViewController.modalPresentationStyle = .fullScreen
        self.present(partSizeChangeViewController, animated: true, completion: nil)
    }
}
