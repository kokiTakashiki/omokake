//
//  PartSizeChangeViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/04.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit
#if os(xrOS)
final class PartSizeChangeViewController: UIViewController {}
#elseif os(iOS)
import MetalKit

class PartSizeChangeViewController: UIViewController {

    // MARK: IBOutlet

    @IBOutlet private weak var drawView: MTKView!
    @IBOutlet private weak var partSizeSlider: UISlider!
    
    // MARK: Properties

    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    private var renderer: Renderer? = nil

    private var selectKakera: Renderer.KakeraType!
    private var isBlendingEnabled: Bool!
    // next View
    private var partsCount: Int!
    private var albumInfo: AlbumInfo!
    
    //dammy
    private var pressurePointInit: simd_float2 = simd_float2(x: -10000.0, y: -10000.0)
    private var pressureEndPInit: simd_float2 = simd_float2(x: -1.0, y: -1.0)
    private var touchEndFloat: Float = 0.0
    
    private var shareBackgroundColor: MTLClearColor = .black
    
    convenience init(
        selectKakera: Renderer.KakeraType,
        isBlendingEnabled: Bool,
        partsCount: Int,
        albumInfo: AlbumInfo
    ) {
        self.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.selectKakera = selectKakera
        self.isBlendingEnabled = isBlendingEnabled
        self.partsCount = partsCount
        self.albumInfo = albumInfo
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("[PartSizeChangeViewController] Metal is not supported")
        }
        
        drawView.device = defaultDevice
        drawView.clearColor = shareBackgroundColor
        drawView.delegate = self
        
        guard drawView.device != nil else {
            print("[PartSizeChangeViewController] Metal is not supported on this device")
            return
        }
        if selectKakera == .thumbnail {
            partSizeSlider.maximumValue = 400
            partSizeSlider.minimumValue = 50
        }
        
        partSizeSlider.value = recommendSize(selectKakera: selectKakera)
        
        renderer = Renderer(
            mtlView: drawView,
            selectKakera: selectKakera,
            isBlendingEnabled: isBlendingEnabled,
            renderDestination: drawView,
            albumInfo: albumInfo
        )
    }
    
    // MARK: IBAction
    
    @IBAction private func startButtonAction(_ sender: UIButton) {
        self.present()
    }

    @IBAction private func dismissButton(_ sender: UIButton) {
        audio.play(effect: Audio.EffectFiles.transitionDown)
        haptic.play(.impact(.soft))
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func selectColorAction(_ sender: UIButton) {
        audio.playRandom(effects: Audio.EffectFiles.taps)
        haptic.play(.impact(.light))
        shareBackgroundColor = selectBackGroundColor(sender.tag)
    }
}



extension PartSizeChangeViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        view.clearColor = shareBackgroundColor
        guard (
            renderer?.update(
                pressurePointInit: pressurePointInit,
                touchEndFloat: touchEndFloat,
                pressureEndPointInit: pressureEndPInit,
                customSize: partSizeSlider.value
            )
        ) != nil else {
            fatalError("[PartSizeChangeViewController] renderer in not init")
        }
    }
}

extension PartSizeChangeViewController {
    private func selectBackGroundColor(_ selectButtonTag: Int) -> MTLClearColor {
        switch selectButtonTag {
        case 1:
            return .convertUIColor(.myBackgroundMagenta)
        case 2:
            return .convertUIColor(.myBackgroundCyaan)
        case 3:
            return .convertUIColor(.myBackgroundGreen)
        case 4:
            return .convertUIColor(.myBackgroundYellow)
        case 5:
            return .convertUIColor(.myBackgroundOrange)
        case 6:
            return .black
        default:
            return .black
        }
    }
    
    private func present() {
        audio.play(effect: Audio.EffectFiles.transitionUp)
        haptic.play(.impact(.medium))
        let drawViewController = instantiateStoryBoardToViewController(storyBoardName: "DrawViewController", withIdentifier: "DrawViewController") as! DrawViewController
        drawViewController.partsCount = partsCount
        drawViewController.selectKakera = selectKakera
        drawViewController.isBlendingEnabled = isBlendingEnabled
        drawViewController.albumInfo = albumInfo
        drawViewController.customSize = partSizeSlider.value
        drawViewController.shareBackgroundColor = shareBackgroundColor
        drawViewController.modalPresentationStyle = .fullScreen
        drawViewController.modalTransitionStyle = .crossDissolve
        self.present(drawViewController, animated: true, completion: nil)
    }
    
    private func recommendSize(selectKakera: Renderer.KakeraType) -> Float {
        if selectKakera == .thumbnail {
            return 225
        } else {
            guard let count = partsCount else { return 0.0 }
            switch count {
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
}
#endif
