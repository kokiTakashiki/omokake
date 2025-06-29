//
//  StoryboardLoadable.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/04/25.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit

/// **A protocol** for types that can be loaded from storyboards.
///
/// Types conforming to this protocol can create instances from storyboards
/// using a standardized naming convention.
@MainActor
public protocol StoryboardLoadable {
    
    /// **The identifier** used to instantiate the view controller from the storyboard.
    static var identifier: String { get }
    
    /// **The storyboard** containing this view controller.
    static var storyboard: UIStoryboard { get }
    
    /// **Loads** a view controller from the storyboard using a custom creator.
    ///
    /// - Parameter creator: A closure that creates the view controller from an NSCoder.
    /// - Returns: A view controller instance of the specified type.
    static func load<T: UIViewController>(using creator: @escaping ((NSCoder) -> T?)) -> T
}

// MARK: Default implementations
public extension StoryboardLoadable {
    
    /// **The default identifier** based on the type name.
    static var identifier: String {
        return String(describing: self)
    }
    
    /// **The default storyboard** with the same name as the type.
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: nil)
    }
    
    /// **Loads** a view controller from the storyboard using a custom creator.
    ///
    /// - Parameter creator: A closure that creates the view controller from an NSCoder.
    /// - Returns: A view controller instance of the specified type.
    static func load<T: UIViewController>(using creator: @escaping ((NSCoder) -> T?)) -> T {
        storyboard.instantiateViewController(identifier: identifier,
                                             creator: creator)
    }
}
