//
//  UIViewController+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/12/18.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateStoryBoardToUIViewController() -> UIViewController {
        let storyBoardName = String(describing: self.classForCoder())
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyBoardName)
        return viewController
    }

    static func makeStoryBoardToViewController<ViewController>(creator: @escaping (NSCoder) -> ViewController?) -> ViewController where ViewController : UIViewController {
        let storyBoardName = String(describing: self.classForCoder())
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: storyBoardName, creator: creator)
        return viewController
    }
}
