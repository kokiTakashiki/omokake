//
//  HapticFeedbackController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/14.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit

enum ImpactFeedbackStyle: Int {
    case light
    case medium
    case heavy
    case soft
    case rigid

#if os(xrOS)

#elseif os(iOS)
    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        return .init(rawValue: rawValue)!
    }
#endif
}

enum NotificationFeedbackType: Int {
    case success
    case failure
    case error

#if os(xrOS)

#elseif os(iOS)
    var value: UINotificationFeedbackGenerator.FeedbackType {
        return .init(rawValue: rawValue)!
    }
#endif
}

enum Haptic {
    case impact(_ style: ImpactFeedbackStyle, intensity: CGFloat? = nil)
    case notification(_ type: NotificationFeedbackType)
    case selection
}

final class HapticFeedbackController {

    static let shared = HapticFeedbackController()
    private init() {}

#if os(xrOS)

#elseif os(iOS)
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var notificationFeedbackGenerator: UINotificationFeedbackGenerator?
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
#endif

    func play(_ haptic: Haptic) {
        switch haptic {
        case .impact(let style, let intensity):
#if os(xrOS)

#elseif os(iOS)
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style.value)
            impactFeedbackGenerator?.prepare()
            
            if let intensity = intensity {
                impactFeedbackGenerator?.impactOccurred(intensity: intensity)
            } else {
                impactFeedbackGenerator?.impactOccurred()
            }
            impactFeedbackGenerator = nil
#endif
        case .notification(let type):
#if os(xrOS)

#elseif os(iOS)
            notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator?.prepare()
            notificationFeedbackGenerator?.notificationOccurred(type.value)
            notificationFeedbackGenerator = nil
#endif
        case .selection:
#if os(xrOS)

#elseif os(iOS)
            selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator?.prepare()
            selectionFeedbackGenerator = nil
#endif
        }
    }

}
