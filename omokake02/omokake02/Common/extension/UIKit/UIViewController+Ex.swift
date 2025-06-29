//
//  UIViewController+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/12/18.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

extension UIViewController {
    /// **Creates** a view controller instance from a storyboard with the same name as the class.
    ///
    /// - Returns: A UIViewController instance loaded from the storyboard.
    static func makeViewController() -> UIViewController {
        let storyBoardName = String(describing: self.classForCoder())
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyBoardName)
        return viewController
    }

    /// **Creates** a view controller instance from a storyboard using a custom creator.
    ///
    /// - Parameter creator: A closure that creates the view controller from an NSCoder.
    /// - Returns: A view controller instance of the specified type.
    static func makeViewController<ViewController>(
        using creator: @escaping (NSCoder) -> ViewController?
    ) -> ViewController where ViewController : UIViewController {
        let storyBoardName = String(describing: self.classForCoder())
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: storyBoardName, creator: creator)
        return viewController
    }
}
