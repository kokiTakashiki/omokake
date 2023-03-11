//
//  ShowApprovalViewController.swift
//  omokake02
//
//  Created by takasiki on 10/15/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit

class ShowApprovalViewController: UIViewController {
    
    var status:String = "norn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func settingButton(_ sender: Any) {
        //ユーザー許可を呼び出す仕掛け
        status = PhotosManager.Authorization()
    }
    
    
    @IBAction func changeVCButton(_ sender: Any) {
        //状況の更新用
        status = PhotosManager.Authorization()
        switch status {
        case "Authorized":
            self.performSegue(withIdentifier: "AuthorizedSegue", sender: nil)
        case "limited":
            self.performSegue(withIdentifier: "DeniedSegue", sender: nil)
        case "Denied":
            self.performSegue(withIdentifier: "DeniedSegue", sender: nil)
        default:
            break
        }
    }
    
}