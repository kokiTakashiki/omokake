//
//  CreditView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/04/29.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct CreditView: View {

    private let actionSNDLink: () -> Void
    private let actionDeviceKitLink: () -> Void

    init(
        actionSNDLink: @escaping () -> Void,
        actionDeviceKitLink: @escaping () -> Void
    ) {
        self.actionSNDLink = actionSNDLink
        self.actionDeviceKitLink = actionDeviceKitLink
    }

    var body: some View {
        ZStack {
            decorativeFrame
            VStack {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                titleText("Credit")
                HStack {
                    describedText(
                        "Developing by",
                        isFixedSizeHorizontal: true,
                        hasTrailingSpace: false
                    )
                    describedText(
                        "DevelopingByName",
                        alignedTo: .trailing,
                        isFixedSizeHorizontal: true,
                        hasLeadingSpace: false
                    )
                }

                HStack {
                    describedText(
                        "Icon Design",
                        isFixedSizeHorizontal: true,
                        hasTrailingSpace: false
                    )
                    describedText(
                        "IconDesignName",
                        alignedTo: .trailing,
                        isFixedSizeHorizontal: true,
                        hasLeadingSpace: false
                    )
                }

                HStack {
                    describedText(
                        "Special Thanks",
                        isFixedSizeHorizontal: true,
                        hasTrailingSpace: false
                    )
                    describedText(
                        "SpecialThanksName",
                        alignedTo: .trailing,
                        isFixedSizeHorizontal: true,
                        hasLeadingSpace: false
                    )
                }

                HStack(spacing: 0) {
                    Text("SND")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.makeFuturaMedium(size: 18))
                    Spacer()
                    Button(action: {
                        actionSNDLink()
                    }, label: {
                        Text("https://snd.dev/")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.makeFuturaMedium(size: 14))
                    })
                }
                .padding(.leading, 28)
                .padding(.trailing, 26)
                HStack(spacing: 0) {
                    Text("DeviceKit")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.makeFuturaMedium(size: 18))
                    Spacer()
                    Button(action: {
                        actionDeviceKitLink()
                    }, label: {
                        Text("https://github.com/devicekit/DeviceKit")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.makeFuturaMedium(size: 14))
                    })
                }
                .padding(.leading, 28)
                .padding(.trailing, 26)
                HStack(spacing: 0) {
                    Text("AnimationSequence")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.makeFuturaMedium(size: 18))
                    Spacer()
                    Button(action: {
                        actionDeviceKitLink()
                    }, label: {
                        Text("https://github.com/cristhianleonli/AnimationSequence")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.makeFuturaMedium(size: 14))
                    })
                }
                .padding(.leading, 28)
                .padding(.trailing, 26)
                Spacer()
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {

        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            CreditView(actionSNDLink: {}, actionDeviceKitLink: {})
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
