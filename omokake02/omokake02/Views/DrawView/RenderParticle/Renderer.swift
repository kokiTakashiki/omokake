//
//  Renderer.swift
//  omokake02
//
//  Created by takasiki on 10/6/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import MetalKit

protocol RenderDestinationProvider {
    var currentRenderPassDescriptor: MTLRenderPassDescriptor? { get }
    var currentDrawable: CAMetalDrawable? { get }
    var colorPixelFormat: MTLPixelFormat { get set }
    //var depthStencilPixelFormat: MTLPixelFormat { get set }
    //var sampleCount: Int { get set }
}

extension Renderer {
    enum KakeraType {
        case sankaku
        case sikaku
        case thumbnail
    }
}

class Renderer {
    static private(set) var device: MTLDevice!
    private(set) var partsCount: Int = 0

    private let drawableSize: CGSize!
    private var renderDestination: RenderDestinationProvider
    
    private let commandQueue: MTLCommandQueue?
    private var computePipelineState: MTLComputePipelineState!
    private var renderPipelineState: MTLRenderPipelineState!

    private let startDate = Date()
    private var setParticles: [ParticleSetup] = []

    init(
        mtlView: MTKView,
        partsCount: Int,
        selectKakera: KakeraType,
        isBlendingEnabled: Bool,
        renderDestination: RenderDestinationProvider,
        albumInfo: AlbumInfo
    ) {
        Renderer.self.device = mtlView.device
        self.drawableSize = mtlView.drawableSize
        self.commandQueue = Renderer.self.device.makeCommandQueue()
        self.partsCount = partsCount
        self.renderDestination = renderDestination
        mtlView.framebufferOnly = false
        
        loadMetal(isBlendingEnabled: isBlendingEnabled)
        partsSetUp(mtlView, selectKakera: selectKakera, albumInfo: albumInfo)
    }
    
    init(
        mtlView: MTKView,
        selectKakera: KakeraType,
        isBlendingEnabled: Bool,
        renderDestination: RenderDestinationProvider,
        albumInfo: AlbumInfo
    ) {
        Renderer.self.device = mtlView.device
        self.drawableSize = mtlView.drawableSize
        self.commandQueue = Renderer.self.device.makeCommandQueue()
        self.partsCount = 1
        self.renderDestination = renderDestination
        mtlView.framebufferOnly = false
        
        loadMetal(isBlendingEnabled: isBlendingEnabled)
        onePartsSetUp(mtlView, selectKakera: selectKakera, albumInfo: albumInfo)
    }
}

// MARK: Create
extension Renderer {
    private func createOmokake(mtlView: MTKView, startPosition: simd_float2, imageName: String, imageName2: String, colorCount: Int) {
        if partsCount == 0 { return } // ならセットアップはしない。
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
    
    private func partsSetUp(_ mtlView: MTKView, selectKakera: KakeraType, albumInfo: AlbumInfo) {
        let colorCount = Int.random(in: 1...4)
        
        switch selectKakera {
        case .sankaku:
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)),
                          imageName: "kakera",
                          imageName2: "kakera2",
                          colorCount: colorCount)
        case .sikaku:
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height * 0.0)),
                          imageName: "kakeraS1",
                          imageName2: "kakeraS2",
                          colorCount: colorCount)
        case .thumbnail: // 400 以内じゃないとFPSがきつい iPhone11 Pro iPhone6s 250 以内
            let thumbnailSize = CGSize(width: 20, height: 20)
            var originalArray:[UIImage] = []
            switch albumInfo.type {
            case .favorites:
                var partsMaxCount = albumInfo.photosCount
                print("[Renderer] partCount", albumInfo.photosCount)
                if albumInfo.photosCount > partsCount {
                    partsMaxCount = partsCount
                }
                originalArray = PhotosManager.favoriteThumbnail(albumInfo: albumInfo, partsCount: partsMaxCount, thumbnailSize: thumbnailSize)
            case .regular:
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
        }
    }
    
    private func onePartsSetUp(_ mtlView: MTKView, selectKakera: KakeraType, albumInfo: AlbumInfo) {
        let colorCount = Int.random(in: 1...4)
        
        switch selectKakera {
        case .sankaku:
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height/2.0)),
                          imageName: "kakera",
                          imageName2: "kakera2",
                          colorCount: colorCount)
        case .sikaku:
            createOmokake(mtlView: mtlView,
                          startPosition: simd_float2(Float(mtlView.drawableSize.width/2.0), Float(mtlView.drawableSize.height/2.0)),
                          imageName: "kakeraS1",
                          imageName2: "kakeraS2",
                          colorCount: colorCount)
        case .thumbnail:
            let thumbnailSize = CGSize(width: 20, height: 20)
            var originalArray:[UIImage] = []
            switch albumInfo.type {
            case .favorites:
                var partsMaxCount = albumInfo.photosCount
                print("[Renderer] partCount", albumInfo.photosCount)
                if albumInfo.photosCount > partsCount {
                    partsMaxCount = partsCount
                }
                originalArray = PhotosManager.favoriteThumbnail(albumInfo: albumInfo, partsCount: partsMaxCount, thumbnailSize: thumbnailSize)
            case .regular:
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
        }
    }
}

// MARK: loadMetal
extension Renderer {
    private func loadMetal(isBlendingEnabled: Bool) {
        // Load all the shader files with a metal file extension in the project
        guard
            let defaultLibrary = Renderer.device.makeDefaultLibrary(),
            let computeFunc = defaultLibrary.makeFunction(name: "perticleCompute")
        else {
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
    func update(
        pressurePointInit: simd_float2,
        isTouchEnd: Bool,
        pressureEndPointInit: simd_float2,
        customSize: Float
    ) -> Int {
        
        for setParticle in setParticles {
            setParticle.generate()
        }
        
        guard let commandBuffer = commandQueue?.makeCommandBuffer(), let renderPassDescriptor = renderDestination.currentRenderPassDescriptor,
            let currentDrawable = renderDestination.currentDrawable else {
            return 0
        }
        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return 0
        }
        computeEncoder.setComputePipelineState(computePipelineState)
        
        for setParticle in setParticles {
            guard
                let timeBuffer = Renderer.device.makeBuffer(length: MemoryLayout<Float>.size, options: []),
                let pressureBuffer = Renderer.device.makeBuffer(length: MemoryLayout<simd_float2>.size, options: []),
                let pressureEndBuffer = Renderer.device.makeBuffer(length: MemoryLayout<simd_float2>.size, options: []),
                let touchEndBool = Renderer.device.makeBuffer(length: MemoryLayout<uint>.size, options: [])
            else { return 0 }

            timeBuffer.label = "time"
            let timeBufferPointer = timeBuffer.contents().bindMemory(
                to: Float.self,
                capacity: 1 / MemoryLayout<Float>.stride
            )
            timeBufferPointer[0] = Float(Date().timeIntervalSince(startDate))
            
            // pressurePoint
            pressureBuffer.label = "pressureZone1"
            let pressureBufferPointer = pressureBuffer.contents().bindMemory(
                to: simd_float2.self,
                capacity: 1 / MemoryLayout<simd_float2>.stride
            )
            pressureBufferPointer[0] = simd_float2(
                pressurePointInit.x * Float(drawableSize.width),
                pressurePointInit.y * Float(drawableSize.height)
            )
            
            // pressureEndPoint
            pressureEndBuffer.label = "pressureEndPoint"
            let pressureEndBufferPointer = pressureEndBuffer.contents().bindMemory(
                to: simd_float2.self,
                capacity: 1 / MemoryLayout<simd_float2>.stride
            )
            pressureEndBufferPointer[0] = simd_float2(
                pressureEndPointInit.x * Float(drawableSize.width),
                pressureEndPointInit.y * Float(drawableSize.height)
            )
            
            touchEndBool.label = "touchEndBool"
            let touchEndBoolPointer = touchEndBool.contents().bindMemory(
                to: Int.self,
                capacity: 1 / MemoryLayout<Int>.stride
            )
            touchEndBoolPointer[0] = isTouchEnd ? 1 : 0
            
            computeEncoder.setBuffer(timeBuffer, offset: 0, index: 2)
            computeEncoder.setBuffer(pressureBuffer, offset: 0, index: 3)
            computeEncoder.setBuffer(pressureEndBuffer, offset: 0, index: 4)
            computeEncoder.setBuffer(touchEndBool, offset: 0, index: 5)
            computeEncoder.setBuffer(setParticle.particleBuffer, offset: 0, index: 0)
            computeEncoder.setBytes(&setParticle.particleCount,length: MemoryLayout<uint>.stride, index: 1)
            
            //dispatchThreads(computeEncoder: computeEncoder, particleCount: setParticle.particleCount)
            if Renderer.device.supportsFeatureSet(.iOS_GPUFamily4_v1) {
                dispatchThreads(computeEncoder: computeEncoder, particleCount: setParticle.particleCount)
            } else {
                let threadsPerThreadgroup = MTLSize(width: min(computePipelineState.threadExecutionWidth,setParticle.currentParticles), height: 1, depth: 1)
                let groupsPerGrid = MTLSize(width: setParticle.currentParticles / min(computePipelineState.threadExecutionWidth,setParticle.currentParticles) + 1, height: 1, depth: 1)
                computeEncoder.dispatchThreadgroups(groupsPerGrid,threadsPerThreadgroup: threadsPerThreadgroup)
            }
        }
        computeEncoder.endEncoding()
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        ) else { return 0 }
        renderEncoder.setRenderPipelineState(renderPipelineState)
        var size = simd_float2(Float(drawableSize.width), Float(drawableSize.height))
        renderEncoder.setVertexBytes(
            &size,
            length: MemoryLayout<simd_float2>.stride,
            index: 0
        )
        
        // label用
        var allCurrentParticles = 0
        
        for setParticle in setParticles {
            renderEncoder.setVertexBuffer(setParticle.particleBuffer,offset: 0, index: 1)
            renderEncoder.setVertexBytes(&setParticle.position,
                                         length: MemoryLayout<simd_float2>.stride,
                                         index: 2)
            
            guard let customSizeBuffer = Renderer.device.makeBuffer(
                length: MemoryLayout<Float>.size,
                options: []
            ) else { return 0 }
            customSizeBuffer.label = "customSizeBuffer"
            let customSizeBufferPointer = customSizeBuffer.contents().bindMemory(
                to: Float.self,
                capacity: 1 / MemoryLayout<Float>.stride
            )
            customSizeBufferPointer[0] = customSize
            
            renderEncoder.setVertexBuffer(customSizeBuffer,offset: 0, index: 3)
            renderEncoder.setFragmentTexture(setParticle.particleTexture, index: 0)
            renderEncoder.drawPrimitives(
                type: .point,
                vertexStart: 0,
                vertexCount: 1,
                instanceCount: setParticle.currentParticles
            )
            allCurrentParticles += setParticle.currentParticles
        }
        renderEncoder.endEncoding()
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
        
        return allCurrentParticles
    }
    
    private func dispatchThreads(computeEncoder: MTLComputeCommandEncoder, particleCount: Int) {
        let threadsPerGrid = MTLSizeMake(particleCount, 1, 1)
        let threadsPerGroup = MTLSizeMake(computePipelineState.threadExecutionWidth, 1, 1)
        computeEncoder.dispatchThreads(
            threadsPerGrid,
            threadsPerThreadgroup: threadsPerGroup
        )
    }
}
