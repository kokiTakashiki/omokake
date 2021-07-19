//
//  Renderer.swift
//  omokake02
//
//  Created by takasiki on 10/6/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

//import Foundation
import MetalKit

protocol RenderDestinationProvider {
    var currentRenderPassDescriptor: MTLRenderPassDescriptor? { get }
    var currentDrawable: CAMetalDrawable? { get }
    var colorPixelFormat: MTLPixelFormat { get set }
    //var depthStencilPixelFormat: MTLPixelFormat { get set }
    //var sampleCount: Int { get set }
}

class Renderer: NSObject {
    static var device: MTLDevice!
    let drawableSize: CGSize!
    var renderDestination: RenderDestinationProvider
    
    let commandQ: MTLCommandQueue
    var computePipelineState: MTLComputePipelineState!
    var renderPipelineState: MTLRenderPipelineState!
    let startDate = Date()
    
    var setParticles: [ParticleSetup] = []
    
    var partsCount: Int!
    
    init?(mtlView: MTKView, partsCount: Int, selectKakera: String, isBlendingEnabled: Bool, renderDestination: RenderDestinationProvider) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQ = device.makeCommandQueue() else {
            return nil
        }
        
        Renderer.self.device = mtlView.device
        self.drawableSize = mtlView.drawableSize
        //print("DrawW",drawableSize.width,"DrawH",drawableSize.height)
        self.commandQ = commandQ
        self.partsCount = partsCount
        self.renderDestination = renderDestination
        super.init()
        mtlView.framebufferOnly = false
        
        loadMetal(isBlendingEnabled: isBlendingEnabled)
        
        let colorCount = Int.random(in: 1...4)
        
        switch selectKakera {
        case "sankaku":
            let omokak = omokake(size: mtlView.drawableSize, texture: ParticleSetup.loadTexture(imageName: "kakera")!, colorCount: colorCount)
            //生成地点
            let randpartsCount = partsCount / Int.random(in: 3...10)
            print("randpartsCount",randpartsCount)
            omokak.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
            omokak.particleCount = partsCount - randpartsCount
            setParticles.append(omokak)
            
            let omokak2 = omokake2(size: mtlView.drawableSize, texture: ParticleSetup.loadTexture(imageName: "kakera2")!, colorCount: colorCount)
            //生成地点
            omokak2.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
            omokak2.particleCount = randpartsCount
            setParticles.append(omokak2)
        case "sikaku":
            let omokak = omokake(size: mtlView.drawableSize, texture: ParticleSetup.loadTexture(imageName: "kakeraS1")!, colorCount: colorCount)
            //生成地点
            let randpartsCount = partsCount / Int.random(in: 3...10)
            print("randpartsCount",randpartsCount)
            omokak.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
            omokak.particleCount = partsCount - randpartsCount
            setParticles.append(omokak)
            
            let omokak2 = omokake2(size: mtlView.drawableSize, texture: ParticleSetup.loadTexture(imageName: "kakeraS2")!, colorCount: colorCount)
            //生成地点
            omokak2.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
            omokak2.particleCount = randpartsCount
            setParticles.append(omokak2)
        case "thumbnail": // 400 以内じゃないとFPSがきつい iPhone11 Pro iPhone6s 250 以内
            let thumbnailSize = CGSize(width: 20, height: 20)
            print("partCount", partsCount)
            let originalArray:[UIImage] = PhotosManager.thumbnail(partsCount: 400,thumbnailSize: thumbnailSize)
            self.partsCount = 50
            for cell in 0..<originalArray.count {
                //originalArray = originalArray + presentor.getThumbnail(indexPathRow: cell, thumbnailSize: thumbnailSize)
                print("配列の数は\(cell)です")
                let omokak = omokake(size: mtlView.drawableSize,
                                     texture: ParticleSetup.loadTextureImage(image: originalArray[cell]), colorCount: 0)
                //生成地点
                //let randpartsCount = partsCount / Int.random(in: 3...10)
                //print("randpartsCount",randpartsCount)
                omokak.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
                omokak.particleCount = 1//partsCount - randpartsCount
                setParticles.append(omokak)
                
//                let omokak2 = omokake2(size: mtlView.drawableSize,
//                                       texture: ParticleSetup.loadTextureImage(image: presentor.getThumbnail(indexPathRow: cell,
//                                                                                                             thumbnailSize: thumbnailSize)[0]))
//                //生成地点
//                omokak2.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
//                omokak2.particleCount = randpartsCount
//                setParticles.append(omokak2)
            }
        default:
            print("select is falier")
        }
        
    }
    
    private func loadMetal(isBlendingEnabled: Bool) {
        // Load all the shader files with a metal file extension in the project
        guard let defaultLibrary = Renderer.device.makeDefaultLibrary(), let computeFunc = defaultLibrary.makeFunction(name: "perticleCompute") else {
            return
        }
        
        do {
            try computePipelineState = Renderer.device.makeComputePipelineState(function: computeFunc)
        } catch let error {
            print("Failed to created commpute pipeline state, error \(error)")
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
            try renderPipelineState = Renderer.device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
        } catch let error {
            print("Failed to created render pipeline state, error \(error)")
        }
    }
    
    //public func draw(in view: MTKView) {
    func update(pressurePointInit: float2, touchEndFloat: Float, pressureEndPointInit: float2){
        
        for setParticle in setParticles {
            setParticle.generate()
        }
        
        guard let commandBuf = commandQ.makeCommandBuffer(), let renderPassDescriptor = renderDestination.currentRenderPassDescriptor,
            let currentDrawable = renderDestination.currentDrawable else {
            return
        }
        guard let computeEncoder = commandBuf.makeComputeCommandEncoder() else {
            return
        }
        computeEncoder.setComputePipelineState(computePipelineState)
        let threadsPerGroup = MTLSizeMake(computePipelineState.threadExecutionWidth, 1, 1)
        func dispatchThreads(particleCount: Int) {
            let threadsPerGrid = MTLSizeMake(particleCount, 1, 1)
            computeEncoder.dispatchThreads(threadsPerGrid,threadsPerThreadgroup: threadsPerGroup)
        }
        
        for setParticle in setParticles {
            var timeBuffer: MTLBuffer! = nil
            timeBuffer = Renderer.device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
            timeBuffer.label = "time"
            let vTimeData = timeBuffer.contents().bindMemory(to: Float.self, capacity: 1 / MemoryLayout<Float>.stride)
            vTimeData[0] = Float(Date().timeIntervalSince(startDate))
            
            // pressurePoint
            var pressureBuffer1: MTLBuffer! = nil
            pressureBuffer1 = Renderer.device.makeBuffer(length: MemoryLayout<float2>.size, options: [])
            pressureBuffer1.label = "pressureZone1"
            let vPressureBuffer1Data = pressureBuffer1.contents().bindMemory(to: float2.self, capacity: 1 / MemoryLayout<float2>.stride)
            vPressureBuffer1Data[0] = float2(pressurePointInit.x * Float(drawableSize.width),pressurePointInit.y * Float(drawableSize.height))
            
            // pressureEndPoint
            var pressureEndBuffer1: MTLBuffer! = nil
            pressureEndBuffer1 = Renderer.device.makeBuffer(length: MemoryLayout<float2>.size, options: [])
            pressureEndBuffer1.label = "pressureEndPoint"
            let pressureEndBuffer1Data = pressureEndBuffer1.contents().bindMemory(to: float2.self, capacity: 1 / MemoryLayout<float2>.stride)
            pressureEndBuffer1Data[0] = float2(pressureEndPointInit.x * Float(drawableSize.width),pressureEndPointInit.y * Float(drawableSize.height))
            
            var touchEndBool: MTLBuffer! = nil
            touchEndBool = Renderer.device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
            touchEndBool.label = "touchEndBool"
            let touchEndBoolData = touchEndBool.contents().bindMemory(to: Float.self, capacity: 1 / MemoryLayout<Float>.stride)
            touchEndBoolData[0] = touchEndFloat
            
            computeEncoder.setBuffer(timeBuffer, offset: 0, index: 2)
            computeEncoder.setBuffer(pressureBuffer1, offset: 0, index: 3)
            computeEncoder.setBuffer(pressureEndBuffer1, offset: 0, index: 4)
            computeEncoder.setBuffer(touchEndBool, offset: 0, index: 5)
            computeEncoder.setBuffer(setParticle.particleBuffer, offset: 0, index: 0)
            computeEncoder.setBytes(&setParticle.particleCount,length: MemoryLayout<uint>.stride, index: 1)
            
            if Renderer.device.supportsFeatureSet(.iOS_GPUFamily4_v1) {
                dispatchThreads(particleCount: setParticle.particleCount)
            } else {
                let threadsPerThreadgroup = MTLSize(width: min(computePipelineState.threadExecutionWidth,setParticle.currentParticles), height: 1, depth: 1)
                let groupsPerGrid = MTLSize(width: setParticle.currentParticles / min(computePipelineState.threadExecutionWidth,setParticle.currentParticles) + 1, height: 1, depth: 1)
                computeEncoder.dispatchThreadgroups(groupsPerGrid,threadsPerThreadgroup: threadsPerThreadgroup)
            }
        }
        computeEncoder.endEncoding()
        
        
        let renderEncoder = commandBuf.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(renderPipelineState)
        var size = float2(Float(drawableSize.width),Float(drawableSize.height))
        renderEncoder.setVertexBytes(&size,
                                     length: MemoryLayout<float2>.stride,
                                     index: 0)
        for setParticle in setParticles {
            renderEncoder.setVertexBuffer(setParticle.particleBuffer,offset: 0, index: 1)
            renderEncoder.setVertexBytes(&setParticle.position,
                                         length: MemoryLayout<float2>.stride,
                                         index: 2)
            renderEncoder.setFragmentTexture(setParticle.particleTexture, index: 0)
            renderEncoder.drawPrimitives(type: .point, vertexStart: 0,
                                         vertexCount: 1,
                                         instanceCount: setParticle.currentParticles)
        }
        renderEncoder.endEncoding()
        commandBuf.present(currentDrawable)
        commandBuf.commit()
        
        
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
