//
//  PartSizeChangeViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/04.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit
import MetalKit

extension MTKView : SinglePartRenderDestinationProvider {}

class PartSizeChangeViewController: UIViewController {
    @IBOutlet weak var drawView: MTKView!
    @IBOutlet weak var partSizeSlider: UISlider!
    
    var renderer: SinglePartRenderer? = nil
    
    var selectKakera:String = ""
    var isBlendingEnabled:Bool = false
    
    // next View
    var partsCount:Int = 1
    var albumInfo:AlbumInfo = AlbumInfo(index: 0, title: "", photosCount: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }
        drawView.device = defaultDevice
        drawView.backgroundColor = UIColor.black
        drawView.delegate = self
        
        guard drawView.device != nil else {
            print("[DrawViewController] Metal is not supported on this device")
            return
        }
        
        renderer = SinglePartRenderer(mtlView: drawView,
                                      selectKakera: selectKakera,
                                      isBlendingEnabled: isBlendingEnabled,
                                      renderDestination: drawView)
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        self.present()
    }
}

extension PartSizeChangeViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
    }
}

extension PartSizeChangeViewController {
    private func present() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let drawViewController = mainStoryboard.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
        drawViewController.partsCount = partsCount
        drawViewController.selectKakera = selectKakera
        drawViewController.isBlendingEnabled = isBlendingEnabled
        drawViewController.albumInfo = albumInfo
        drawViewController.modalPresentationStyle = .fullScreen
        drawViewController.modalTransitionStyle = .crossDissolve
        self.present(drawViewController, animated: true, completion: nil)
    }
}
