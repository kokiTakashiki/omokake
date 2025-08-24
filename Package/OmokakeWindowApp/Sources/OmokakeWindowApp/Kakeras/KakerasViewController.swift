//
//  KakerasViewController.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/18.
//

import MetalKit
#if os(iOS)
    import UIKit

    typealias PlatformViewController = UIViewController
#elseif os(macOS)
    import AppKit

    typealias PlatformViewController = NSViewController
#endif

@available(iOS 26.0, macOS 26.0, *)
final class KakerasViewController: PlatformViewController {
    private lazy var mtkView: MTKView = {
        let view = MTKView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var renderer: KakerasRendererProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
            view.backgroundColor = .black
        #endif
        view.addSubview(mtkView)
        NSLayoutConstraint.activate([
            mtkView.topAnchor.constraint(equalTo: view.topAnchor),
            mtkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mtkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mtkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // Metal Setup
        mtkView.device = MTLCreateSystemDefaultDevice()
        // assert(mtkView.device == nil, "This system doesn't support Metal.")

        if mtkView.device?.supportsFamily(.metal4) == true {
            renderer = KakerasRenderer(with: mtkView)
            // assert(renderer == nil, "This system doesn't support Metal.")
        } else {
            assert(mtkView.device == nil, "This system doesn't support Metal.")
        }

        mtkView.clearColor = .init()
        renderer?.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }
}
