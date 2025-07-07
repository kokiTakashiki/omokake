//
//  UILabel+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/16.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

extension UILabel{

    /// **Applies** an outline effect to the label text.
    ///
    /// - Parameters:
    ///   - strokeWidth: The width of the stroke (should be negative for outline effect).
    ///   - outlineColor: The color of the outline.
    ///   - foregroundColor: The color of the text inside the outline.
    func applyOutline(
        strokeWidth: CGFloat,
        outlineColor: UIColor,
        foregroundColor: UIColor
    ) {
        let strokeTextAttributes = [
            .strokeColor : outlineColor,
            .foregroundColor : foregroundColor,
            .strokeWidth : strokeWidth,
            .font : self.font as Any
        ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
}
