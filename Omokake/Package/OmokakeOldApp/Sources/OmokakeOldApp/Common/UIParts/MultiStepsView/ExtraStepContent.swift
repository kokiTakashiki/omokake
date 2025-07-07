//
//  ExtraStepContent.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct ExtraStepContent: View {
    let index : Int
    let color : Color
    let extraContent : [String]
    let extraContentSize : CGSize?
    var body: some View {
        ZStack {
            if let extra = extraContent[safe: index] {
                if UIImage(systemName: extra) != nil {
                    Image(systemName: extra)
                } else {
                    Text(extra)
                }
            }
        }
        .foregroundColor(color)
        .frame(width: extraContentSize?.width, height: extraContentSize?.height)
    }
}

struct ExtraStepContent_Previews: PreviewProvider {
    static var previews: some View {
        ExtraStepContent(
            index: 0,
            color: .accentColor,
            extraContent: ["scribble.variable"],
            extraContentSize: CGSize(width: 30, height: 30))
    }
}
