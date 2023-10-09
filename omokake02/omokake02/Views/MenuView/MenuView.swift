//
//  MenuView.swift
//  omokake02
//
//  Created by takedatakashiki on 2023/10/07.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI
import AnimationSequence

extension MenuView {
    struct AnimationState {
        var kakeraOpacity: CGFloat = 0.0
        var sKakeraOpacity: CGFloat = 0.0
        var thumbnailOpacity: CGFloat = 0.0
    }
}

struct MenuView: View {
    @EnvironmentObject private var environmentObject: MenuViewEnvironmentObject

    private static let buttonWidth = (UIScreen.main.bounds.width / 2) - 28
    @State private var animationState = AnimationState()

    var body: some View {
        let localizedString = NSLocalizedString("LimitedGeneratingKakera", comment: "")
        let messageString = String(format: localizedString, "\(environmentObject.maxParts)","\(environmentObject.maxParts)")
        ZStack {
            main
            questionmarkButton
        }
        .okAlert(
            "TakeMorePhotos",
            messageKey: "200orMore",
            isPresented: $environmentObject.takeMorePhotosShowingAlert
        ) {
            Task { @MainActor in
                environmentObject.takeMorePhotosAlertOKAction()
            }
        }
        .okAlert(
            "BestPhotographer",
            messageText: messageString,
            isPresented: $environmentObject.limitedGeneratingKakeraShowingAlert
        ) {
            Task { @MainActor in
                environmentObject.limitedGeneratingKakeraAlertOKAction()
            }
        }
        .onAppear {
            animateViews()
        }
    }

    private func animateViews() {
        AnimationSequence(duration: 0.6, delay: 0, easing: .default)
            .append {
                animationState.kakeraOpacity = 1.0
            }
            .append {
                animationState.sKakeraOpacity = 1.0
            }
            .append {
                animationState.thumbnailOpacity = 1.0
            }
            .start()
    }

    private var main: some View {
        VStack {
            Text("kakera")
                .font(.futuraMedium(size: 45))
            HStack {
                Text("kakeraNumberHelpText")
                    .font(.futuraMedium(size: 17))
                Spacer()
            }
            
            HStack {
                Text("\(environmentObject.partsCount) kakera")
                    .font(.futuraMedium(size: 17))
                Spacer()
            }

            Spacer()

            buttons

            Spacer()
        }
        .padding(.horizontal, 28)
    }

    private var buttons: some View {
        HStack(spacing: 0) {
            VStack(spacing: 48) {
                Button {
                    Task { @MainActor in
                        environmentObject.sankakuAction()
                    }
                } label: {
                    Image("buttonKakera")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: Self.buttonWidth, height: Self.buttonWidth)
                        .opacity(animationState.kakeraOpacity)
                }
                
                Button {
                    Task { @MainActor in
                        environmentObject.thumbnailAction()
                    }
                } label: {
                    Image("buttonThumbnail")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: Self.buttonWidth, height: Self.buttonWidth)
                        .opacity(animationState.thumbnailOpacity)
                }
            }
            VStack {
                Button {
                    Task { @MainActor in
                        environmentObject.sikakuAction()
                    }
                } label: {
                    Image("buttonSKakera")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: Self.buttonWidth, height: Self.buttonWidth)
                        .opacity(animationState.sKakeraOpacity)
                }
            }
        }
    }

    private var questionmarkButton: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    environmentObject.questionmarkButtonAction()
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .padding(.trailing, 20)
    }
}

fileprivate let localizationIds = ["en", "ja"]

#Preview("Localized - \(localizationIds[0])") {
    MenuView()
        .environmentObject(MenuViewEnvironmentObject())
        .environment(\.locale, .init(identifier: localizationIds[0]))
}

#Preview("Localized - \(localizationIds[1])") {
    MenuView()
        .environmentObject(MenuViewEnvironmentObject())
        .environment(\.locale, .init(identifier: localizationIds[1]))
}
