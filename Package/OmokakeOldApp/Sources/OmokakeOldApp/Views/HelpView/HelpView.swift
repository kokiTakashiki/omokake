//
//  HelpView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/10.
//  Copyright © 2023 takasiki. All rights reserved.
//

import OmokakeModel
import SwiftUI

struct HelpView: View {
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    var body: some View {
        ScrollView {
            VStack {
                ScreenExplanationView()
                TouchInteractionExplanationView()
                CreditView(actionSNDLink: {
                    Task { @MainActor in
                        audio.playRandom(effects: Audio.EffectFiles.taps)
                        haptic.play(.impact(.soft))
                        await openURLAction("https://snd.dev/")
                    }
                }, actionDeviceKitLink: {
                    Task { @MainActor in
                        audio.playRandom(effects: Audio.EffectFiles.taps)
                        haptic.play(.impact(.soft))
                        await openURLAction("https://github.com/devicekit/DeviceKit")
                    }
                })
                ContactUsView(action: {
                    Task { @MainActor in
                        audio.playRandom(effects: Audio.EffectFiles.taps)
                        haptic.play(.impact(.soft))
                        await twitterButtonAction()
                    }
                })
            }
        }
    }
}

// MARK: Action

extension HelpView {
    @MainActor
    private func twitterButtonAction() async {
        guard let url = URL(string: "twitter://") else { return }
        if UIApplication.shared.canOpenURL(url) {
            guard let twitterURL = URL(string: "twitter://user?screen_name=bluewhitered123") else { return }
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: { result in
                print(result) // → true
            })
        } else {
            guard let twitterURL = URL(string: "https://twitter.com/bluewhitered123") else { return }
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: { result in
                print(result) // → true
            })
        }
    }

    @MainActor
    private func openURLAction(_ urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: { result in
            print(result) // → true
        })
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {

        let localizationIDs = ["en", "ja"]

        ForEach(localizationIDs, id: \.self) { id in

            HelpView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
