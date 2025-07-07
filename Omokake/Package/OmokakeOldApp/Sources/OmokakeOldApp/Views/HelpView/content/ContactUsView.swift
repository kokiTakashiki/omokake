//
//  ContactUsView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/04/29.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct ContactUsView: View {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        ZStack {
            decorativeFrame
            VStack {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.clear)
                titleText("ContactUs")
                HStack(spacing: 0) {
                    Text("Twitter")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.makeFuturaMedium(size: 18))
                    Spacer()
                    Button(action: {
                        action()
                    }, label: {
                        Text("@bluewhitered123")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.makeFuturaMedium(size: 18))
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

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {

        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            ContactUsView(action: {})
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
