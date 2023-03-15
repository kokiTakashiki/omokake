//
//  ViewController.swift
//  omokake02
//
//  Created by takasiki on 10/6/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import UIKit
import MetalKit

class DrawViewController: UIViewController, MTKViewDelegate {
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared
    
    @IBOutlet weak var drawView: MTKView!
    @IBOutlet weak var partsCountLabel: UILabel!
    
    var renderer: Renderer!
    var pressurePointInit:simd_float2 = simd_float2(x: -10000.0, y: -10000.0)
    var pressureEndPInit:simd_float2 = simd_float2(x: -1.0, y: -1.0)
    var touchEndFloat:Float = 0.0
    
    var partsCount:Int = 0
    var selectKakera: Renderer.KakeraType = .sankaku//:Array<String> = ["kakera","kakera2"]
    var isBlendingEnabled:Bool = false
    var customSize:Float = 1.0
    
    // thumbnail用
    var albumInfo:AlbumInfo = AlbumInfo(index: 0, title: "", type: .regular, photosCount: 0)
    
    var shareBackgroundColor:MTLClearColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }
        self.view.backgroundColor = .convertMTLClearColor(shareBackgroundColor)
        drawView.device = defaultDevice
        drawView.clearColor = shareBackgroundColor
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
        
        if selectKakera != .thumbnail {
            customSize = recommendSize()
        }
        partsCountLabel.makeOutLine(strokeWidth: -3.0, oulineColor: .gray, foregroundColor: .lightGray)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        let result = renderer.update(pressurePointInit: pressurePointInit, touchEndFloat: touchEndFloat, pressureEndPointInit: pressureEndPInit, customSize: customSize)
        //フェードオン！
        if fadeOn {
            fadeOut()
        }
        partsCountLabel.text = "\(result)"
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
        guard let touchLocation = (touch?.location(in: drawView)) else { return }
        let touchInit = simd_float2(x: Float((touchLocation.x - drawView.bounds.width/2) / drawView.bounds.width ),
        y: Float( (drawView.bounds.height - touchLocation.y) / drawView.bounds.height ) )
        pressurePointInit = touchInit
        //print(pressurePoint)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = touches.first
        guard let touchLocation = (touch?.location(in: drawView)) else { return }
        let touchInit = simd_float2(x: Float((touchLocation.x - drawView.bounds.width/2) / drawView.bounds.width ),
        y: Float( (drawView.bounds.height - touchLocation.y) / drawView.bounds.height ) )
        pressurePointInit = touchInit
        //print(pressurePointInit)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        guard let touchLocation = (touch?.location(in: drawView)) else { return }
        let touchInit = simd_float2(x: Float((touchLocation.x - drawView.bounds.width/2) / drawView.bounds.width ),
        y: Float( (drawView.bounds.height - touchLocation.y) / drawView.bounds.height ) )
        pressureEndPInit = touchInit
        pressurePointInit = simd_float2(x: -10000.0, y: -10000.0)
        touchEndFloat = 1.0
        fadeOn = true
    }

    @IBAction func backMenuAction(_ sender: UIButton) {
        audio.play(effect: Audio.EffectFiles.transitionDown)
        haptic.play(.impact(.soft))
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        // スクリーンショットを取得
        guard let shareImage = selectScreenShot().jpegData(compressionQuality: 0.7) else { return }
        //shareImage.alpha
        // 共有項目
        let activityItems: [Any] = [shareImage, "\(partsCountLabel.text ?? "0")kakera\n#omokake思い出のかけら"]
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

extension DrawViewController {
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
    
    private func selectScreenShot()-> UIImage {
        //コンテキスト開始
        UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, false, 0.0)
        //viewを書き出す
        self.drawView.drawHierarchy(in: self.drawView.bounds, afterScreenUpdates: true)
        // imageにコンテキストの内容を書き出す
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //コンテキストを閉じる
        UIGraphicsEndImageContext()
        return image.resizeImage(maxSize: 4194304) ?? UIImage.emptyImage(color: .black, frame: CGRect.zero)
    }
}
