//
//  TouchInteractionExplanationView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/04/29.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct TouchInteractionExplanationView: View {
    var body: some View {
        ZStack {
            decorativeFrame
            VStack {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                titleText("TouchInteraction")
                describedTextWithImage(imageName: "shusoku", "TouchInteractionDescription1")
                describedTextWithImage(imageName: "kakusan", "TouchInteractionDescription2")
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

struct TouchInteractionExplanationView_Previews: PreviewProvider {
    static var previews: some View {

        let localizationIDs = ["en", "ja"]

        ForEach(localizationIDs, id: \.self) { id in

            TouchInteractionExplanationView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
