//
//  ViewController.swift
//  omokake02
//
//  Created by takasiki on 10/6/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import UIKit
import MetalKit

extension MTKView : RenderDestinationProvider {
}

class DrawViewController: UIViewController, MTKViewDelegate {
    
    @IBOutlet weak var drawView: MTKView!
    
    var renderer: Renderer!
    var pressurePointInit:float2 = float2(x: -10000.0, y: -10000.0)
    var pressureEndPInit:float2 = float2(x: -1.0, y: -1.0)
    var touchEndFloat:Float = 0.0
    
    var partsCount:Int = 0
    var selectKakera:String = ""//:Array<String> = ["kakera","kakera2"]
    var isBlendingEnabled:Bool = false
    
    // thumbnail用
    var albumInfo:AlbumInfo = AlbumInfo(index: 0, title: "", photosCount: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        renderer = Renderer(mtlView: drawView,
                            partsCount: partsCount,
                            selectKakera: selectKakera,
                            isBlendingEnabled: isBlendingEnabled,
                            renderDestination: drawView,
                            albumInfo: albumInfo)
        //print("width",drawView.bounds.width,"height",drawView.bounds.height)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        renderer.update(pressurePointInit: pressurePointInit, touchEndFloat: touchEndFloat, pressureEndPointInit: pressureEndPInit)
        //フェードオン！
        if fadeOn {
            fadeOut()
        }
        //print("touchEndFloat",touchEndFloat)
    }
    
    //フェードアウト用変数
    var fadeOn:Bool = false
    var mainasu:Float = 0.05
    var fadeOutCount:Float = 0.25
    //フェードアウト関数
    func fadeOut(){
        //ボリュームが0になるまで徐々に落とす、0になったらメモリ解放
        if fadeOutCount > 0{
            fadeOutCount -= mainasu
            //緩やかなボリュームの絞り
            if fadeOutCount < 0.5 && mainasu > 0.01{
               self.mainasu -= 0.01
            }
        }else if fadeOutCount < 0{
            //reset
            fadeOutCount = 0.25
            touchEndFloat = 0.0
            fadeOn = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        let touchLocation = (touch?.location(in: drawView))!
        let touchInit = float2(x: Float((touchLocation.x - drawView.bounds.width/2) / drawView.bounds.width ),
        y: Float( (drawView.bounds.height - touchLocation.y) / drawView.bounds.height ) )
        pressurePointInit = touchInit
        //print(pressurePoint)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = touches.first
        let touchLocation = (touch?.location(in: drawView))!
        let touchInit = float2(x: Float((touchLocation.x - drawView.bounds.width/2) / drawView.bounds.width ),
        y: Float( (drawView.bounds.height - touchLocation.y) / drawView.bounds.height ) )
        pressurePointInit = touchInit
        //print(pressurePointInit)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        let touchLocation = (touch?.location(in: drawView))!
        let touchInit = float2(x: Float((touchLocation.x - drawView.bounds.width/2) / drawView.bounds.width ),
        y: Float( (drawView.bounds.height - touchLocation.y) / drawView.bounds.height ) )
        pressureEndPInit = touchInit
        pressurePointInit = float2(x: -10000.0, y: -10000.0)
        touchEndFloat = 1.0
        fadeOn = true
        //count = 0.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuViewGo" {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

