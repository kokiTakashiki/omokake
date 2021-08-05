//
//  PartSizeChangeViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/04.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit
import MetalKit

class PartSizeChangeViewController: UIViewController {
    @IBOutlet weak var drawView: MTKView!
    @IBOutlet weak var partSizeSlider: UISlider!
    
    var renderer: Renderer? = nil
    
    var selectKakera:String = ""
    var isBlendingEnabled:Bool = false
    
    // next View
    var partsCount:Int = 1
    var albumInfo:AlbumInfo = AlbumInfo(index: 0, title: "", photosCount: 0)
    
    //dammy
    var pressurePointInit:simd_float2 = simd_float2(x: -10000.0, y: -10000.0)
    var pressureEndPInit:simd_float2 = simd_float2(x: -1.0, y: -1.0)
    var touchEndFloat:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("[PartSizeChangeViewController] Metal is not supported")
        }
        drawView.device = defaultDevice
        drawView.backgroundColor = UIColor.black
        drawView.delegate = self
        
        guard drawView.device != nil else {
            print("[PartSizeChangeViewController] Metal is not supported on this device")
            return
        }
        
        partSizeSlider.value = recommendSize()
        
        renderer = Renderer(mtlView: drawView,
                            partsCount: 1,
                            selectKakera: selectKakera + "Size",
                            isBlendingEnabled: isBlendingEnabled,
                            renderDestination: drawView,
                            albumInfo: albumInfo)
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        self.present()
    }
}

extension PartSizeChangeViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard (renderer?.update(pressurePointInit: pressurePointInit, touchEndFloat: touchEndFloat, pressureEndPointInit: pressureEndPInit, customSize: partSizeSlider.value)) != nil else {
            fatalError("[PartSizeChangeViewController] renderer in not init")
        }
        print("[PartSizeChangeViewController] partSizeSlider",partSizeSlider.value)
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
    
    private func recommendSize() -> Float {
        switch partsCount {
            case 1...50:
                return 100.0
            case 51...100:
                return 80.0
            case 101...500:
                return 50.0
            case 501...1000:
                return 30.0
            case 1001...2000:
                return 22.0
            case 2001...3000:
                return 20.0
            case 3001...6000:
                return 15.0
            case 6001...50000:
                return 11.0
            case 50001...100000:
                return 7.0
            case 100001...400000:
                return 5.0
            default:
                return 0.0
       }
    }
}
