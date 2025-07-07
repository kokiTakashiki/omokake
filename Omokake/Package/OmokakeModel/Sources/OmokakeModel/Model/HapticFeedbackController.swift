//
//  HapticFeedbackController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/14.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit

@available(iOS 13, *)
public enum ImpactFeedbackStyle: Int {
    case light
    case medium
    case heavy
    case soft
    case rigid

    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        return .init(rawValue: rawValue)!
    }

}

@available(iOS 13, *)
public enum NotificationFeedbackType: Int {
    case success
    case failure
    case error

    var value: UINotificationFeedbackGenerator.FeedbackType {
        return .init(rawValue: rawValue)!
    }

}

@available(iOS 13, *)
public enum Haptic {
    case impact(_ style: ImpactFeedbackStyle, intensity: CGFloat? = nil)
    case notification(_ type: NotificationFeedbackType)
    case selection
}

@available(iOS 13, *)
@MainActor
public final class HapticFeedbackController {

    public static let shared = HapticFeedbackController()
    private init() {}
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var notificationFeedbackGenerator: UINotificationFeedbackGenerator?
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?

    public func play(_ haptic: Haptic) {
        switch haptic {
        case .impact(let style, let intensity):
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style.value)
            impactFeedbackGenerator?.prepare()
            
            if let intensity = intensity {
                impactFeedbackGenerator?.impactOccurred(intensity: intensity)
            } else {
                impactFeedbackGenerator?.impactOccurred()
            }
            impactFeedbackGenerator = nil

        case .notification(let type):
            notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator?.prepare()
            notificationFeedbackGenerator?.notificationOccurred(type.value)
            notificationFeedbackGenerator = nil

        case .selection:
            selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator?.prepare()
            selectionFeedbackGenerator = nil
        }
    }

}
