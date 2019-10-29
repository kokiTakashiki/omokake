//
//  FlowSelectViewController.swift
//  omokake02
//
//  Created by takasiki on 10/20/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit

class FlowSelectViewController: UIViewController {
    
    var partsCount:Int = 0
    var selectKakera:Array<String> = ["kakera","kakera2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goDrawView" {
            
            let drawViewController:DrawViewController = segue.destination as! DrawViewController
            drawViewController.modalTransitionStyle = .crossDissolve
            
            //print("2asset count",partsCount)
            //ここで写真の枚数を送ります。
            drawViewController.partsCount = partsCount
            drawViewController.selectKakera = selectKakera
            //self.dismiss(animated: true, completion: nil)
            //self.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.dismiss(animated: true, completion: nil)
    }
}
