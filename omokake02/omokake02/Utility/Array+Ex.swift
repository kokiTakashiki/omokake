//
//  Array+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/12.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation

// MTLTextures 用
extension Array {
    subscript (safe index: Index) -> Element? {
        //indexが配列内なら要素を返し、配列外ならnilを返す（三項演算子）
        return indices.contains(index) ? self[index] : self.first
    }
}
