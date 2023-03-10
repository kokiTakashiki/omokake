//
//  TitleViewController.swift
//  omokake02
//
//  Created by takasiki on 10/14/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit

class TitleViewController: UIViewController {
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var tutorialOff:Bool = false
    var menuOn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let loadedTutorialOff = defaults.object(forKey: "tutorialOff")
        if (loadedTutorialOff as? Bool != nil) {
            tutorialOff = loadedTutorialOff as! Bool
        }
        let loadedMenuOn = defaults.object(forKey: "menuOn")
        if (loadedMenuOn as? Bool != nil) {
            menuOn = loadedMenuOn as! Bool
        }
        
        if tutorialOff {
            tutorialButton.isHidden = true
        }
        
        if menuOn {
            menuButton.isHidden = false
        }
        
    }
}

// MARK: IBAction
extension TitleViewController {
    @IBAction func tutorialButtonAction(_ sender: Any) {
        let tutorialViewController = instantiateStoryBoardToViewController(storyBoardName: "TutorialView", withIdentifier: "TutorialViewController") as! TutorialViewController
        tutorialViewController.modalPresentationStyle = .fullScreen
        self.present(tutorialViewController, animated: true, completion: nil)
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        let menuViewController = instantiateStoryBoardToViewController(storyBoardName: "MenuViewController", withIdentifier: "MenuView") as! MenuViewController
        let navi = UINavigationController(rootViewController: menuViewController)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true, completion: nil)
    }
}
