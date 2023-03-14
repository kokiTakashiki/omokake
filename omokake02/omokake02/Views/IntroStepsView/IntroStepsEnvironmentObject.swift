//
//  IntroStepsEnvironmentObject.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/13.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
final class IntroStepsEnvironmentObject: ObservableObject {
    @Published var status: [IntroStepsState] = [.infoOmokake]
    @Published var currentStatus: IntroStepsState = .infoOmokake
    @Published var photoAccessState: PhotoAccessState = .none
    @Published var showingIndicator = false
    let tapHowToUseNextButtonSubject = PassthroughSubject<Bool, Never>()

    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    func bottomButtonAction() async {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.soft))

        switch currentStatus {
        case .infoOmokake:
            Task {
                await updateStatus()
            }
        case .approval:
            showingIndicator = true
            Task {
                self.photoAccessState = await self.authorization()
                Task {
                    await updateStatus()
                }
            }
        case .complete:
            Task {
                await updateStatus()
            }
        case .howToUse:
            tapHowToUseNextButtonSubject.send(true)
        }
    }

    func approvalViewAction() async {
        showingIndicator = true
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.soft))

        Task {
            self.photoAccessState = await self.authorization()
            Task {
                await self.updateStatus()
            }
        }
    }

    func deniedViewAction() async {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.soft))

        // 設定画面に飛ぶしかけ
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func bottomBackButtonAction() async {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.soft))

        photoAccessState = .none
    }

    private func updateStatus() async {
        if photoAccessState == .none || photoAccessState == .Authorized {
            // update status
            if !status.contains(currentStatus.next()) {
                currentStatus = currentStatus.next()
                status.append(currentStatus)
            }
        }
    }
    
    private func authorization() async -> PhotoAccessState {
        let state: PhotoAccessState = PhotosManager.Authorization()
        sleep(2)
        showingIndicator = false
        if state == .Authorized {
            audio.play(effect: Audio.EffectFiles.celebration)
            haptic.play(.notification(.success))
        } else {
            haptic.play(.notification(.error))
        }
        return state
    }
}
