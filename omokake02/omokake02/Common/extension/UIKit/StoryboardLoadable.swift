//
//  StoryboardLoadable.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/04/25.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit

@MainActor
public protocol StoryboardLoadable {
    
    static var identifier: String { get }
    
    static var storyboard: UIStoryboard { get }
    
    static func load<T: UIViewController>(creator: @escaping ((NSCoder) -> T?)) -> T
}

// MARK: Default implementations
public extension StoryboardLoadable {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: nil)
    }
    
    static func load<T: UIViewController>(creator: @escaping ((NSCoder) -> T?)) -> T {
        storyboard.instantiateViewController(identifier: identifier,
                                             creator: creator)
    }
}
