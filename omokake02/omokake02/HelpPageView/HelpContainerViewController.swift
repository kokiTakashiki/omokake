//
//  HelpContainerViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/26.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation
import UIKit

class HelpContainerViewController: UIViewController {
    @IBAction func twitterButtonAction(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string: "twitter://")!) {
            guard let twitterUrl = URL(string: "twitter://user?screen_name=bluewhitered123") else { return }
            UIApplication.shared.open(twitterUrl, options: [:], completionHandler: { result in
                print(result) // → true
            })
        } else {
            guard let twitterUrl = URL(string: "https://twitter.com/bluewhitered123") else { return }
            UIApplication.shared.open(twitterUrl, options: [:], completionHandler: { result in
                print(result) // → true
            })
        }
    }
}
