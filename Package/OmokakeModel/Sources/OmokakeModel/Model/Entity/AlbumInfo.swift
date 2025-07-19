//
//  AlbumInfo.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/15.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation

public struct AlbumInfo {
    public let index: Int
    public let title: String
    public let type: Self.AlbumType
    public let photosCount: Int

    public init(index: Int, title: String, type: Self.AlbumType, photosCount: Int) {
        self.index = index
        self.title = title
        self.type = type
        self.photosCount = photosCount
    }
}

public extension AlbumInfo {
    enum AlbumType {
        case favorites
        case regular
    }
}
