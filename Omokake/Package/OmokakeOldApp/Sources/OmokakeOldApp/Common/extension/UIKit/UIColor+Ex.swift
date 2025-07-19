//
//  UIColor+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/06.
//  Copyright © 2021 takasiki. All rights reserved.
//

import MetalKit
import UIKit

extension UIColor {
    /// **Creates** a UIColor from an MTLClearColor.
    ///
    /// This performs a value-preserving type conversion from Metal's clear color
    /// representation to UIKit's color representation.
    ///
    /// - Parameter clearColor: The MTLClearColor to convert.
    /// - Returns: A UIColor with equivalent color values.
    static func makeColor(from clearColor: MTLClearColor) -> UIColor {
        UIColor(
            red: CGFloat(clearColor.red),
            green: CGFloat(clearColor.green),
            blue: CGFloat(clearColor.blue),
            alpha: CGFloat(clearColor.alpha)
        )
    }
}
