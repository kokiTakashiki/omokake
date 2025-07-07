//
//  ScreenExplanationView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/04/28.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct ScreenExplanationView: View {
    var body: some View {
        ZStack {
            decorativeFrame
            VStack {
                Group {
                    Rectangle()
                        .frame(height: 20)
                        .foregroundColor(.clear)
                    titleText("ScreenExplanation")
                    describedText("ScreenDescription")
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.clear)
                    describedText("KakeraScreenDescription")
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.clear)
                    describedText("omokakeScreenDescription")
                    describedTextWithIcon(systemName: "square.and.arrow.up", "ShareButton")
                    describedText("ShareButtonDescription")
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                describedText("SelectAlbumScreenDescription")
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                describedText("KakeraSettingScreenDescription")
                Spacer()
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct ScreenExplanationView_Previews: PreviewProvider {
    static var previews: some View {

        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            ScreenExplanationView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
