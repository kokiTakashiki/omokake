//
//  AlbumInfo.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/15.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation

enum AlbumType {
    case favorites
    case regular
}

class AlbumInfo {
    var index: Int
    var title: String
    var type: AlbumType
    var photosCount: Int
    
    init(index: Int, title: String, type: AlbumType, photosCount: Int) {
        self.index = index
        self.title = title
        self.type = type
        self.photosCount = photosCount
    }
}
