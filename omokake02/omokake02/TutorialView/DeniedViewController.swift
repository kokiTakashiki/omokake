//
//  DeniedViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/10.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation
import UIKit

class DeniedViewController: UIViewController {
    @IBAction func settingAction(_ sender: Any) {
        // 設定画面に飛ぶしかけ
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
