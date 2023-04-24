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
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    struct ViewModel {
        var partsCoint: Int
        let selectKakera: Renderer.KakeraType //:Array<String> = ["kakera","kakera2"]
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
    private var albumData = [AlbumInfo]()
    private var viewModel: ViewModel
    
    init?(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
        audio.play(effect: Audio.EffectFiles.transitionDown)
        haptic.play(.impact(.soft))
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Extension Private Method
extension SelectAlbumViewController {
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://www.antutu.com/en/ranking/ios1.htm
    private func deviceMaxParts(_ note: AlbumInfo) {
        let device = Device.current
        print("[SelectAlbumViewController] deviceMaxParts \(device)")
        switch device {
        case .iPhoneXR, .iPhoneXSMax, .iPhoneXS, .iPhoneSE2:
            partsAlertAndPresent(note, maxParts: 300)

        case .iPhone11, .iPhone11ProMax, .iPhone11Pro,
                .iPhone12Pro, .iPhone12, .iPhone12ProMax, .iPhone12Mini,
                .iPhoneSE3, .iPhone13Mini, .iPhone13,
                .iPhone14, .iPhone14Plus, .iPhone13Pro,
                .iPhone13ProMax, .iPhone14ProMax, .iPhone14Pro:
            partsAlertAndPresent(note, maxParts: 400)

        default:
            partsAlertAndPresent(note, maxParts: 200)
        }
    }
    
    // 6s 200
    // 11Pro 400
    private func partsAlertAndPresent(_ note: AlbumInfo, maxParts: Int) {
        if note.photosCount < 10 {
            let alert = UIAlertController(
                title: NSLocalizedString("TakeMorePhotos", comment: ""),
                message: NSLocalizedString("10orMore", comment: ""),
                preferredStyle:  .alert
            )
            let defaultAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.present(note)
            }
            alert.addAction(defaultAction)
            audio.play(effect: Audio.EffectFiles.caution)
            haptic.play(.notification(.failure))
            present(alert, animated: true, completion: nil)

        } else if note.photosCount > maxParts {
            // TODO: 現状maxpartで制限かける。次期アップデートでかけら量を自由に変更できる画面を用意する予定。\nその限界を超えたあなたに特別な機能を\n用意しました。
            viewModel.partsCoint = maxParts

            let titleLocalizedString = NSLocalizedString("LimitPhotos", comment: "")
            let titleString = String(format: titleLocalizedString, "\(maxParts)")
            let localizedString = NSLocalizedString("CappedPhotos", comment: "")
            let messageString = String(format: localizedString, "\(maxParts)")

            let alert = UIAlertController(
                title: titleString,
                message: messageString,
                preferredStyle:  .alert
            )
            let defaultAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.present(note)
            }
            alert.addAction(defaultAction)
            audio.play(effect: Audio.EffectFiles.caution)
            haptic.play(.notification(.failure))
            present(alert, animated: true, completion: nil)
        } else {
            self.present(note)
        }
    }
    
    private func present(_ note: AlbumInfo) {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.medium))

        let partSizeChangeViewController = PartSizeChangeViewController(
            selectKakera: viewModel.selectKakera,
            isBlendingEnabled: viewModel.isBlendingEnabled,
            partsCount: viewModel.partsCoint,
            albumInfo: note
        )
        partSizeChangeViewController.modalPresentationStyle = .fullScreen
        self.present(partSizeChangeViewController, animated: true, completion: nil)
    }
}
