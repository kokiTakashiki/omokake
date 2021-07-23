//
//  AlbumInfo.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/15.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation

class AlbumInfo {
    var index: Int
    var title: String
    var photosCount: Int
    
    init(index: Int, title: String, photosCount: Int) {
        self.index = index
        self.title = title
        self.photosCount = photosCount
    }
}
