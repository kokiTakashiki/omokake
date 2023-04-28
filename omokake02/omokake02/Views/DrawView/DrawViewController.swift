//
//  ViewController.swift
//  omokake02
//
//  Created by takasiki on 10/6/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import UIKit
import MetalKit

final class DrawViewController: UIViewController, MTKViewDelegate {
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared
    
    @IBOutlet private weak var drawView: MTKView!
    @IBOutlet private weak var partsCountLabel: UILabel!
    
    private var renderer: Renderer?
    private var pressurePointInit: simd_float2 = simd_float2(x: -10000.0, y: -10000.0)
    private var pressureEndPInit: simd_float2 = simd_float2(x: -1.0, y: -1.0)
    private var isTouchEnd: Bool = false
    
    private var partsCount: Int
    private var selectKakera: Renderer.KakeraType
    private var isBlendingEnabled: Bool
    private var customSize: Float
    
    // thumbnail用
    private var albumInfo: AlbumInfo
    
    private var shareBackgroundColor: MTLClearColor

    init?(
        coder: NSCoder,
        partsCount: Int,
        selectKakera: Renderer.KakeraType,
        isBlendingEnabled: Bool,
        customSize: Float,
        albumInfo: AlbumInfo,
        shareBackgroundColor: MTLClearColor
    ) {
        self.partsCount = partsCount
        self.selectKakera = selectKakera
        self.isBlendingEnabled = isBlendingEnabled
        self.customSize = customSize
        
        self.albumInfo = albumInfo
        self.shareBackgroundColor = shareBackgroundColor
        
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }

        drawView.device = defaultDevice
        guard drawView.device != nil else {
            print("[DrawViewController] Metal is not supported on this device")
            return
        }
        drawView.clearColor = shareBackgroundColor
        
        self.renderer = Renderer(mtlView: drawView,
                                 partsCount: partsCount,
                                 selectKakera: selectKakera,
                                 isBlendingEnabled: isBlendingEnabled,
                                 renderDestination: drawView,
                                 albumInfo: albumInfo)
        
        self.view.backgroundColor = .convertMTLClearColor(shareBackgroundColor)
        drawView.delegate = self
        //print("width",drawView.bounds.width,"height",drawView.bounds.height)
        
        if selectKakera != .thumbnail {
            customSize = recommendSize()
        }
        partsCountLabel.makeOutLine(strokeWidth: -3.0, oulineColor: .gray, foregroundColor: .lightGray)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let result = renderer?.update(
            pressurePointInit: pressurePointInit,
            isTouchEnd: isTouchEnd,
            pressureEndPointInit: pressureEndPInit,
            customSize: customSize
        ) else { return }
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
            isTouchEnd = false
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
        isTouchEnd = true
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
