//
//  UILabel+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/16.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

extension UILabel{

    /// makeOutLine
    ///
    /// - Parameters:
    ///   - strokeWidth: 線の太さ。負数
    ///   - oulineColor: 線の色
    ///   - foregroundColor: 縁取りの中の色
    func makeOutLine(strokeWidth: CGFloat, oulineColor: UIColor, foregroundColor: UIColor) {
        let strokeTextAttributes = [
            .strokeColor : oulineColor,
            .foregroundColor : foregroundColor,
            .strokeWidth : strokeWidth,
            .font : self.font as Any
        ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
}
