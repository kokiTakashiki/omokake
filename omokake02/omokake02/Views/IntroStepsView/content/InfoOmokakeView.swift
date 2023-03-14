//
//  InfoOmokakeView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct InfoOmokakeView: View {
    var body: some View {
        ScrollView {
            Rectangle()
                .frame(height: 20)
                .foregroundColor(.clear)
            title("AboutOmokake")
            description("AboutOmokakeDescription")
        }
        .padding(.leading, 5.0)
        .padding(.trailing, 5.0)
    }
}

struct InfoOmokakeView_Previews: PreviewProvider {
    static var previews: some View {
        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            InfoOmokakeView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
