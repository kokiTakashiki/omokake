//
//  MenuViewEnvironmentObject.swift
//  omokake02
//
//  Created by takedatakashiki on 2023/10/08.
//  Copyright © 2023 takasiki. All rights reserved.
//

import Combine
import DeviceKit
import OmokakeModel
import SwiftUI

@MainActor
final class MenuViewEnvironmentObject: ObservableObject {
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    private var selectKakera: Renderer.KakeraType = .sankaku

    // for view
    let partsCount: Int
    let maxParts: Int
    @Published var takeMorePhotosShowingAlert = false
    @Published var limitedGeneratingKakeraShowingAlert = false

    // for parent view controller
    let presentSubject = PassthroughSubject < (
        viewController: UIViewController,
        case: MenuViewController.TransitionCase
    ), Never > ()

    init() {
        partsCount = PhotosManager.allPhotoCount()
        maxParts = Device.kakeraMaxParts(.kakera)
    }
}

// MARK: Action

extension MenuViewEnvironmentObject {
    @MainActor
    func questionmarkButtonAction() {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.medium))

        let helpViewController = HelpViewController()
        presentSubject.send((helpViewController, .pushViewController))
    }

    @MainActor
    func sankakuAction() {
        selectKakera = .sankaku // ["kakera","kakera2"]
        partsAlertAndPresent()
    }

    @MainActor
    func sikakuAction() {
        selectKakera = .sikaku // ["kakeraS1","kakeraS2"]
        partsAlertAndPresent()
    }

    @MainActor
    func thumbnailAction() {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.medium))

        let selectAlbumViewController = SelectAlbumViewController.makeViewController {
            let viewController = SelectAlbumViewController(
                coder: $0,
                viewModel: SelectAlbumViewController.ViewModel(
                    partsCoint: self.partsCount,
                    selectKakera: .thumbnail,
                    isBlendingEnabled: false
                )
            )
            viewController?.modalPresentationStyle = .fullScreen
            return viewController
        }
        presentSubject.send((selectAlbumViewController, .modalPresentation))
    }

    @MainActor
    func takeMorePhotosAlertOKAction() {
        presentDrawViewController(drawPartsCount: partsCount)
    }

    @MainActor
    func limitedGeneratingKakeraAlertOKAction() {
        presentDrawViewController(drawPartsCount: maxParts)
    }
}

// MARK: praivate

extension MenuViewEnvironmentObject {
    // 6s 100000
    // 11Pro 300000
    private func partsAlertAndPresent() {
        if partsCount < 200 {
            audio.play(effect: Audio.EffectFiles.caution)
            haptic.play(.notification(.failure))

            takeMorePhotosShowingAlert = true
        } else if partsCount > maxParts {
            // TODO: 現状maxpartで制限かける。次期アップデートでかけら量を自由に変更できる画面を用意する予定。\nその限界を超えたあなたに特別な機能を\n用意しました。
            audio.play(effect: Audio.EffectFiles.caution)
            haptic.play(.notification(.failure))

            limitedGeneratingKakeraShowingAlert = true
        } else {
            presentDrawViewController(drawPartsCount: partsCount)
        }
    }

    private func presentDrawViewController(drawPartsCount: Int) {
        audio.play(effect: Audio.EffectFiles.transitionUp)
        haptic.play(.impact(.soft))

        let drawViewController = DrawViewController.makeViewController {
            let viewController = DrawViewController(
                coder: $0,
                partsCount: drawPartsCount,
                selectKakera: self.selectKakera,
                isBlendingEnabled: true,
                customSize: 1.0,
                albumInfo: AlbumInfo(index: 0, title: "", type: .regular, photosCount: 0),
                shareBackgroundColor: .black
            )
            viewController?.modalPresentationStyle = .fullScreen
            viewController?.modalTransitionStyle = .crossDissolve
            return viewController
        }
        presentSubject.send((drawViewController, .modalPresentation))
    }
}
