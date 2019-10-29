//
//  HelpInteractionViewController.swift
//  omokake02
//
//  Created by takasiki on 10/22/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit

class HelpInteractionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backHelpSelectView" {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
