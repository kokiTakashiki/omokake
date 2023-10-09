//
//  IntroStepsState.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import Foundation

enum IntroStepsState : String, CaseIterable  {
    case infoOmokake
    case approval
    case complete
    case howToUse

    var rawValue: String {
        switch self {
        case .infoOmokake:
            return "info.circle"
        case .approval:
            if #available(iOS 14, *) {
                return "photo.on.rectangle.angled"
            } else {
                return "photo.on.rectangle"
            }
        case .complete:
            return "checkmark.circle.fill"
        case .howToUse:
            return "questionmark.circle"
        }
    }
}
