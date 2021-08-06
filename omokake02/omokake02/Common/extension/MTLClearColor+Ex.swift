//
//  MTLClearColor+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/06.
//  Copyright © 2021 takasiki. All rights reserved.
//

import MetalKit
import UIKit

extension MTLClearColor {
    static var black: MTLClearColor {
        return MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    static var backgroundMagenta: MTLClearColor {
        let color = UIColor.backgroundMagenta.cgColor.components ?? [1.0,1.0,1.0,1.0]
        return MTLClearColor(red: Double(color[0]), green: Double(color[1]), blue: Double(color[2]), alpha: Double(color[3]))
    }
}
