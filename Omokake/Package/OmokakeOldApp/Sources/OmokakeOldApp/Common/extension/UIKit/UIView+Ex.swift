//
//  UIView+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/25.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

extension UIView {
    /// **The corner radius** of the view's layer.
    ///
    /// Setting this property automatically enables `masksToBounds` when the value is greater than 0.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// **The width of the view's border**.
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// **The color of the view's border**.
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? CGColor(gray: 0.0, alpha: 0.0))
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
}
