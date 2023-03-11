//
//  HelpView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/10.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack {
                screenExplanation()
                touchInteraction()
                credit()
                contactUs(action: {
                    Task {
                        twitterButtonAction()
                    }
                })
            }
        }
    }
}

// MARK: Action

extension HelpView {
    @MainActor
    private func twitterButtonAction() {
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
                .padding(.leading, 20)
                .padding(.trailing, 20)
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

// MARK: UIPart
private extension HelpView {
    @ViewBuilder
    func description(_ content: LocalizedStringKey, edge: Edge = .leading) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            switch edge {
            case .leading:
                Text(content)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("Futura Medium", size: 18))
                Spacer()
            case .trailing:
                Spacer()
                Text(content)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("Futura Medium", size: 18))
            case .top:
                EmptyView()
            case .bottom:
                EmptyView()
            }
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    func iconSideDescription(systemName: String, _ content: LocalizedStringKey) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Image(systemName: systemName)
            Text(content)
                .font(.custom("Futura Medium", size: 18))
            Spacer()
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    func imageSideDescription(name: String, _ content: LocalizedStringKey) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3)
            Rectangle()
                .frame(width: 10, height: 20)
                .foregroundColor(.clear)
            Text(content)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Futura Medium", size: 18))
            Spacer()
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    func title(_ content: LocalizedStringKey) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Text(content)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Futura Medium", size: 30))
            Spacer()
        }
    }

    var waku: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.black)
                .padding(.top, 3)
                .padding(.leading, 3)
                .padding(.trailing, 3)
                .padding(.bottom, 3)
        }
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
