//
//  SinglePartRenderer.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/04.
//  Copyright © 2021 takasiki. All rights reserved.
//

import MetalKit

protocol SinglePartRenderDestinationProvider {
    var currentRenderPassDescriptor: MTLRenderPassDescriptor? { get }
    var currentDrawable: CAMetalDrawable? { get }
    var colorPixelFormat: MTLPixelFormat { get set }
    //var depthStencilPixelFormat: MTLPixelFormat { get set }
    //var sampleCount: Int { get set }
}

class SinglePartRenderer: NSObject {
    static var device: MTLDevice!
    let drawableSize: CGSize!
    var renderDestination: SinglePartRenderDestinationProvider
    
    let commandQ: MTLCommandQueue
    var computePipelineState: MTLComputePipelineState!
    var renderPipelineState: MTLRenderPipelineState!
    
    init?(mtlView: MTKView, selectKakera: String, isBlendingEnabled: Bool, renderDestination: SinglePartRenderDestinationProvider) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQ = device.makeCommandQueue() else {
            return nil
        }
        
        SinglePartRenderer.self.device = mtlView.device
        self.drawableSize = mtlView.drawableSize
        //print("DrawW",drawableSize.width,"DrawH",drawableSize.height)
        self.commandQ = commandQ
        self.renderDestination = renderDestination
        super.init()
        mtlView.framebufferOnly = false
        
        loadMetal(isBlendingEnabled: isBlendingEnabled)
    }
}

// MARK: Private
extension SinglePartRenderer {
    private func loadMetal(isBlendingEnabled: Bool) {
        // Load all the shader files with a metal file extension in the project
        guard let defaultLibrary = SinglePartRenderer.device.makeDefaultLibrary(), let computeFunc = defaultLibrary.makeFunction(name: "perticleCompute") else {
            return
        }
        
        do {
            try computePipelineState = SinglePartRenderer.device.makeComputePipelineState(function: computeFunc)
        } catch let error {
            print("[SinglePartRenderer] Failed to created commpute pipeline state, error \(error)")
        }
        
        // Set the default formats needed to render
        //renderDestination.depthStencilPixelFormat = .depth32Float_stencil8
        renderDestination.colorPixelFormat = .bgra8Unorm
        
        let vertexFunc = defaultLibrary.makeFunction(name: "vertexTransform")
        let fragmentFunc = defaultLibrary.makeFunction(name: "fragmentShader")
        
        // Create a pipeline state for rendering the captured image
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.label = "MyRenderPipeline"
        renderPipelineStateDescriptor.vertexFunction = vertexFunc
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunc
        //ピクセルフォーマット
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = renderDestination.colorPixelFormat
        //透明度の許可
        renderPipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha//renderDestination.colorSourceRGBBlendFactor
        //アルファブレンドを許可する
        renderPipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = isBlendingEnabled//renderDestination.colorIsBlendingEnabled
        //
        renderPipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .one//renderDestination.colorDestinationRGBBlendFactor
        //renderPipelineStateDescriptor.stencilAttachmentPixelFormat = renderDestination.depthStencilPixelFormat
        
        do {
            try renderPipelineState = SinglePartRenderer.device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
        } catch let error {
            print("Failed to created render pipeline state, error \(error)")
        }
    }
}
