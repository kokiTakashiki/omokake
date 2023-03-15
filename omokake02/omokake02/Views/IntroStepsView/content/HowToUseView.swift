//
//  HowToUseView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct HowToUseView: View {
    var body: some View {
        ScrollView {
            Group {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                title("HowToUse")
                description("ScreenDescription")
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                description("KakeraScreenDescription")
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                description("omokakeScreenDescription")
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.clear)
            description("SelectAlbumScreenDescription")
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.clear)
            description("KakeraSettingScreenDescription")
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.clear)
            description("HowToUseDescription")
        }
        .padding(.leading, 5.0)
        .padding(.trailing, 5.0)
    }
}

struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            HowToUseView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
