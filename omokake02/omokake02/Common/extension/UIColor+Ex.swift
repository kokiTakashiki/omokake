//
//  UIColor+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/06.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit
import MetalKit

extension UIColor {
    ///
    class var backgroundMagenta: UIColor {
        return UIColor(named: "backgroundMagenta") ?? UIColor.black
    }
    
    static func convertMTLClearColor(_ color:MTLClearColor) -> UIColor {
        return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
}
