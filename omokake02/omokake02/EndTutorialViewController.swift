//
//  EndTutorialViewController.swift
//  omokake02
//
//  Created by takasiki on 10/15/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit

class EndTutorialViewController: UIViewController {
    
    //var titleVC:TitleViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TutorialToMenu" {
            
            let tutorialOff = true
            let defaults = UserDefaults.standard
            defaults.set(tutorialOff, forKey: "tutorialOff")

            let menuOn = true
            //let defaults2 = UserDefaults.standard
            defaults.set(menuOn, forKey: "menuOn")
            
        }
    }
    
}
