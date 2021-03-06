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
    @IBOutlet weak var backGroundView: UIImageView!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tutorial1thView" {
            //let tutorialVC:TutorialViewController = segue.destination as! TutorialViewController
            //drawViewController.modalTransitionStyle = .crossDissolve
            self.dismiss(animated: true, completion: nil)
        }
        
        if segue.identifier == "menuView" {
            //let menuVC:MenuViewController = segue.destination as! MenuViewController
            //drawViewController.modalTransitionStyle = .crossDissolve
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
