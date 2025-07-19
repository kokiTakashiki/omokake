//
//  Font+Ex.swift
//  omokake02
//
//  Created by takedatakashiki on 2023/10/08.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

extension Font {
    /// **Creates** a Futura Medium font with the specified size.
    ///
    /// - Parameter size: The size of the font.
    /// - Returns: A custom Font instance, or nil if the font cannot be loaded.
    static func makeFuturaMedium(size: CGFloat) -> Font? {
        .custom("Futura Medium", size: size)
    }
}
