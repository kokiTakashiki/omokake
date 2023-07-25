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
    /// #e5abbe
    class var myBackgroundMagenta: UIColor {
        return UIColor(named: "backgroundMagenta") ?? UIColor.black
    }
    
    /// #a0d8ef
    class var myBackgroundCyaan: UIColor {
        return UIColor(named: "backgroundCyaan") ?? UIColor.black
    }
    
    /// #00a381
    class var myBackgroundGreen: UIColor {
        return UIColor(named: "backgroundGreen") ?? UIColor.black
    }
    
    /// #ffec47
    class var myBackgroundYellow: UIColor {
        return UIColor(named: "backgroundYellow") ?? UIColor.black
    }
    
    /// #f39800
    class var myBackgroundOrange: UIColor {
        return UIColor(named: "backgroundOrange") ?? UIColor.black
    }
    
    static func convertMTLClearColor(_ color:MTLClearColor) -> UIColor {
        return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
}
