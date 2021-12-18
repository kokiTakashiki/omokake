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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        let tutorialOff = true
        let defaults = UserDefaults.standard
        defaults.set(tutorialOff, forKey: "tutorialOff")

        let menuOn = true
        defaults.set(menuOn, forKey: "menuOn")
        
        let menuViewController = instantiateStoryBoardToViewController(storyBoardName: "MenuViewController", withIdentifier: "MenuView") as! MenuViewController
        menuViewController.modalPresentationStyle = .fullScreen
        menuViewController.modalTransitionStyle = .crossDissolve
        self.present(menuViewController, animated: true, completion: nil)
    }
}
