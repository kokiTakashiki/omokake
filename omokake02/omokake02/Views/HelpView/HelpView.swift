//
//  HelpView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/10.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    var body: some View {
        ScrollView {
            VStack {
                screenExplanation()
                touchInteraction()
                credit()
                contactUs(action: {
                    Task {
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
            guard let twitterUrl = URL(string: "twitter://user?screen_name=bluewhitered123") else { return }
            UIApplication.shared.open(twitterUrl, options: [:], completionHandler: { result in
                print(result) // → true
            })
        } else {
            guard let twitterUrl = URL(string: "https://twitter.com/bluewhitered123") else { return }
            UIApplication.shared.open(twitterUrl, options: [:], completionHandler: { result in
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

// MARK: Parts Groups
private extension HelpView {
    func screenExplanation() -> some View {
        ZStack {
            waku
            VStack {
                Group {
                    Rectangle()
                        .frame(height: 20)
                        .foregroundColor(.clear)
                    title("ScreenExplanation")
                    description("ScreenDescription")
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.clear)
                    description("KakeraScreenDescription")
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.clear)
                    description("omokakeScreenDescription")
                    iconSideDescription(systemName: "square.and.arrow.up", "ShareButton")
                    description("ShareButtonDescription")
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                description("SelectAlbumScreenDescription")
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                description("KakeraSettingScreenDescription")
                Spacer()
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

    func touchInteraction() -> some View {
        ZStack {
            waku
            VStack {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                title("TouchInteraction")
                imageSideDescription(name: "shusoku", "TouchInteractionDescription1")
                imageSideDescription(name: "kakusan", "TouchInteractionDescription2")
                Spacer()
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

    func credit() -> some View {
        ZStack {
            waku
            VStack {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                title("Credit")
                HStack {
                    description("Developing by")
                    Spacer()
                    description("DevelopingByName", edge: .trailing)
                }
                HStack {
                    description("Icon Design")
                    Spacer()
                    description("IconDesignName", edge: .trailing)
                }
                HStack {
                    description("Special Thanks")
                    Spacer()
                    description("SpecialThanksName", edge: .trailing)
                }
                HStack(spacing: 0) {
                    Text("SND")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.custom("Futura Medium", size: 18))
                    Spacer()
                    Button(action: {
                        Task {
                            audio.playRandom(effects: Audio.EffectFiles.taps)
                            haptic.play(.impact(.soft))
                            await openURLAction("https://snd.dev/")
                        }
                    }, label: {
                        Text("https://snd.dev/")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.custom("Futura Medium", size: 18))
                    })
                }
                .padding(.leading, 28)
                .padding(.trailing, 26)
                HStack(spacing: 0) {
                    Text("DeviceKit")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.custom("Futura Medium", size: 18))
                    Spacer()
                    Button(action: {
                        Task {
                            audio.playRandom(effects: Audio.EffectFiles.taps)
                            haptic.play(.impact(.soft))
                            await openURLAction("https://github.com/devicekit/DeviceKit")
                        }
                    }, label: {
                        Text("https://github.com/devicekit/DeviceKit")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.custom("Futura Medium", size: 18))
                    })
                }
                .padding(.leading, 28)
                .padding(.trailing, 26)
                Spacer()
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }

    func contactUs(action: @escaping () -> Void) -> some View {
        ZStack {
            waku
            VStack {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                title("ContactUs")
                HStack(spacing: 0) {
                    Text("Twitter")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.custom("Futura Medium", size: 18))
                    Spacer()
                    Button(action: {
                        action()
                    }, label: {
                        Text("@bluewhitered123")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.custom("Futura Medium", size: 18))
                    })
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {

        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            HelpView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
