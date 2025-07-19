//
//  Index+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/08.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}
