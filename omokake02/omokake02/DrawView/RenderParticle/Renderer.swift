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
    
    var partsCount: Int = 0

    
    init?(mtlView: MTKView, partsCount: Int, selectKakera: String, isBlendingEnabled: Bool, renderDestination: RenderDestinationProvider, albumInfo: AlbumInfo) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQ = device.makeCommandQueue() else {
            return nil
        }
        
        Renderer.self.device = mtlView.device
        self.drawableSize = mtlView.drawableSize
        self.commandQ = commandQ
        self.partsCount = partsCount
        self.renderDestination = renderDestination
        super.init()
        mtlView.framebufferOnly = false
        
        loadMetal(isBlendingEnabled: isBlendingEnabled)
        partsSetUp(mtlView, selectKakera: selectKakera, albumInfo: albumInfo)
    }
}

// MARK: Create
extension Renderer {
    private func createOmokake(mtlView: MTKView, startPosition: simd_float2, imageName: String, imageName2: String, colorCount: Int) {
        if partsCount <= 1 {
            guard let texture = ParticleSetup.loadTexture(imageName: imageName) else { return }
            let omokak = omokake(size: mtlView.drawableSize, texture: texture, colorCount: colorCount)
            //生成地点
            omokak.position = startPosition
            omokak.particleCount = partsCount
            setParticles.append(omokak)
        } else {
            guard let texture = ParticleSetup.loadTexture(imageName: imageName) else { return }
            let omokak = omokake(size: mtlView.drawableSize, texture: texture, colorCount: colorCount)
            //生成地点
            var randpartsCount = partsCount / Int.random(in: 3...10)
            if randpartsCount == 0 { randpartsCount = 1 }
            print("[Renderer] randpartsCount",randpartsCount)
            omokak.position = startPosition
            omokak.particleCount = partsCount - randpartsCount
            setParticles.append(omokak)
            
            guard let texture2 = ParticleSetup.loadTexture(imageName: imageName2) else { return }
            let omokak2 = omokake2(size: mtlView.drawableSize, texture: texture2, colorCount: colorCount)
            //生成地点
            omokak2.position = startPosition
            omokak2.particleCount = randpartsCount
            setParticles.append(omokak2)
        }
    }
    
    private func partsSetUp(_ mtlView: MTKView, selectKakera: String, albumInfo: AlbumInfo) {
        let colorCount = Int.random(in: 1...4)
        
        switch selectKakera {
        case "sankaku":
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)),
                          imageName: "kakera",
                          imageName2: "kakera2",
                          colorCount: colorCount)
        case "sikaku":
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)),
                          imageName: "kakeraS1",
                          imageName2: "kakeraS2",
                          colorCount: colorCount)
        case "thumbnail": // 400 以内じゃないとFPSがきつい iPhone11 Pro iPhone6s 250 以内
            let thumbnailSize = CGSize(width: 20, height: 20)
            var originalArray:[UIImage] = []
            switch albumInfo.title {
            case "お気に入り":
                var partsMaxCount = albumInfo.photosCount
                print("[Renderer] partCount", albumInfo.photosCount)
                if albumInfo.photosCount > partsCount {
                    partsMaxCount = partsCount
                }
                originalArray = PhotosManager.favoriteThumbnail(albumInfo: albumInfo, partsCount: partsMaxCount, thumbnailSize: thumbnailSize)
            default:
                var partsMaxCount = albumInfo.photosCount
                print("[Renderer] partCount", albumInfo.photosCount)
                if albumInfo.photosCount > partsCount {
                    partsMaxCount = partsCount
                }
                originalArray = PhotosManager.selectThumbnail(albumInfo: albumInfo, partsCount: partsMaxCount, thumbnailSize: thumbnailSize)
            }
            for cell in 0..<originalArray.count {
                let omokak = omokakeThumbnail(size: mtlView.drawableSize,
                                              texture: ParticleSetup.loadTextureImage(image: originalArray[cell]),
                                              speed: 1,
                                              speedY: 2,
                                              speedRange: -1.78...0.62)
                omokak.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)]
                omokak.particleCount = 1
                setParticles.append(omokak)
            }
        case "sankakuSize":
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height/2.0)),
                          imageName: "kakera",
                          imageName2: "kakera2",
                          colorCount: colorCount)
        case "sikakuSize":
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height/2.0)),
                          imageName: "kakeraS1",
                          imageName2: "kakeraS2",
                          colorCount: colorCount)
        case "thumbnailSize":
            let thumbnailSize = CGSize(width: 20, height: 20)
            var originalArray:[UIImage] = []
            switch albumInfo.title {
            case "お気に入り":
                var partsMaxCount = albumInfo.photosCount
                print("[Renderer] partCount", albumInfo.photosCount)
                if albumInfo.photosCount > partsCount {
                    partsMaxCount = partsCount
                }
                originalArray = PhotosManager.favoriteThumbnail(albumInfo: albumInfo, partsCount: partsMaxCount, thumbnailSize: thumbnailSize)
            default:
                var partsMaxCount = albumInfo.photosCount
                print("[Renderer] partCount", albumInfo.photosCount)
                if albumInfo.photosCount > partsCount {
                    partsMaxCount = partsCount
                }
                originalArray = PhotosManager.selectThumbnail(albumInfo: albumInfo, partsCount: partsMaxCount, thumbnailSize: thumbnailSize)
            }
            for cell in 0..<originalArray.count {
                let omokak = omokakeThumbnail(size: mtlView.drawableSize,
                                              texture: ParticleSetup.loadTextureImage(image: originalArray[cell]),
                                              speed: 0,
                                              speedY: 0,
                                              speedRange: 0...0)
                omokak.position = [Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height/2.0)]
                omokak.particleCount = 1
                setParticles.append(omokak)
            }
        default:
            print("[Renderer] select is falier")
        }
    }
}

// MARK: loadMetal
extension Renderer {
    private func loadMetal(isBlendingEnabled: Bool) {
        // Load all the shader files with a metal file extension in the project
        guard let defaultLibrary = Renderer.device.makeDefaultLibrary(), let computeFunc = defaultLibrary.makeFunction(name: "perticleCompute") else {
            return
        }
        
        do {
            try computePipelineState = Renderer.device.makeComputePipelineState(function: computeFunc)
        } catch let error {
            print("[Renderer] Failed to created commpute pipeline state, error \(error)")
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
}

// MARK: Update
extension Renderer {
    //public func draw(in view: MTKView) {
    func update(pressurePointInit: simd_float2, touchEndFloat: Float, pressureEndPointInit: simd_float2, customSize: Float) -> Int{
        
        for setParticle in setParticles {
            setParticle.generate()
        }
        
        guard let commandBuf = commandQ.makeCommandBuffer(), let renderPassDescriptor = renderDestination.currentRenderPassDescriptor,
            let currentDrawable = renderDestination.currentDrawable else {
            return 0
        }
        guard let computeEncoder = commandBuf.makeComputeCommandEncoder() else {
            return 0
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
            pressureBuffer1 = Renderer.device.makeBuffer(length: MemoryLayout<simd_float2>.size, options: [])
            pressureBuffer1.label = "pressureZone1"
            let vPressureBuffer1Data = pressureBuffer1.contents().bindMemory(to: simd_float2.self, capacity: 1 / MemoryLayout<simd_float2>.stride)
            vPressureBuffer1Data[0] = simd_float2(pressurePointInit.x * Float(drawableSize.width),pressurePointInit.y * Float(drawableSize.height))
            
            // pressureEndPoint
            var pressureEndBuffer1: MTLBuffer! = nil
            pressureEndBuffer1 = Renderer.device.makeBuffer(length: MemoryLayout<simd_float2>.size, options: [])
            pressureEndBuffer1.label = "pressureEndPoint"
            let pressureEndBuffer1Data = pressureEndBuffer1.contents().bindMemory(to: simd_float2.self, capacity: 1 / MemoryLayout<simd_float2>.stride)
            pressureEndBuffer1Data[0] = simd_float2(pressureEndPointInit.x * Float(drawableSize.width),pressureEndPointInit.y * Float(drawableSize.height))
            
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
        
        guard let renderEncoder = commandBuf.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return 0 }
        renderEncoder.setRenderPipelineState(renderPipelineState)
        var size = simd_float2(Float(drawableSize.width),Float(drawableSize.height))
        renderEncoder.setVertexBytes(&size,
                                     length: MemoryLayout<simd_float2>.stride,
                                     index: 0)
        
        // label用
        var allCurrentParticles = 0
        
        for setParticle in setParticles {
            renderEncoder.setVertexBuffer(setParticle.particleBuffer,offset: 0, index: 1)
            renderEncoder.setVertexBytes(&setParticle.position,
                                         length: MemoryLayout<simd_float2>.stride,
                                         index: 2)
            
            var customSizeBuffer: MTLBuffer! = nil
            customSizeBuffer = Renderer.device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
            customSizeBuffer.label = "customSizeBuffer"
            let customSizeBufferData = customSizeBuffer.contents().bindMemory(to: Float.self, capacity: 1 / MemoryLayout<Float>.stride)
            customSizeBufferData[0] = customSize
            
            renderEncoder.setVertexBuffer(customSizeBuffer,offset: 0, index: 3)
            renderEncoder.setFragmentTexture(setParticle.particleTexture, index: 0)
            renderEncoder.drawPrimitives(type: .point, vertexStart: 0,
                                         vertexCount: 1,
                                         instanceCount: setParticle.currentParticles)
            allCurrentParticles += setParticle.currentParticles
        }
        renderEncoder.endEncoding()
        commandBuf.present(currentDrawable)
        commandBuf.commit()
        
        return allCurrentParticles
    }
}
