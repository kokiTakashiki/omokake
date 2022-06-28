//
//  ParticleSetup.swift
//  omokake02
//
//  Created by takasiki on 10/13/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

//import Foundation
import MetalKit

struct Particle {
    var startPosition: simd_float2
    var position: simd_float2
    var direction: Float
    var directionRange: Float
    var interactionRange: Float
    var color: simd_float4
    var size: Float
    var frame: simd_float2
    var speed: Float
    var speedY: Float
}

struct ParticleDescriptor {
    var startPosition = simd_float2(repeating: 0)
    var position = simd_float2(repeating: 0)
    var direction: Float = 0
    var directionRange: ClosedRange<Float> = 0...0
    var interactionRange: ClosedRange<Float> = 0...0
    var pointSize: Float = 80
    var pointSizeRange: ClosedRange<Float> = 0...0
    var color = simd_float4(repeating: 0)
    var frame = simd_float2(repeating: 0)
    var speed: Float = 0
    var speedRange: ClosedRange<Float> = 0...0
    var speedY: Float = 1
}

class ParticleSetup {
    
    var particleTexture: MTLTexture!
    var particleBuffer: MTLBuffer?
    var particleDescriptor: ParticleDescriptor?
    
    var position: simd_float2 = [0, 0]
    var pointSize: Float = 80
    var currentParticles = 0
    var particleCount: Int = 0 {
        didSet {
            let bufferSize = MemoryLayout<Particle>.stride * particleCount
            guard let buffer = Renderer.device.makeBuffer(length: bufferSize) else { return }
            particleBuffer = buffer
        }
    }
    
    var birthRate = 0
    var birthDelay = 0 {
        didSet {
            birthTimer = birthDelay
        }
    }
    private var birthTimer = 0
    
    func generate() {
        if currentParticles >= particleCount {
            return
        }
        guard let particleBuffer = particleBuffer,
            let pdescriptor = particleDescriptor else {
                return
        }
        
        birthTimer += 1
        if birthTimer < birthDelay {
            return
        }
        birthTimer = 0
        
        var pointer = particleBuffer.contents().bindMemory(to: Particle.self, capacity: particleCount)
        pointer = pointer.advanced(by: currentParticles)
        for _ in 0..<birthRate {
            pointer.pointee.position = pdescriptor.position
            pointer.pointee.startPosition = pdescriptor.startPosition
            pointer.pointee.size = pdescriptor.pointSize
            pointer.pointee.direction = pdescriptor.direction + .random(in: pdescriptor.directionRange)
            pointer.pointee.interactionRange = .random(in: pdescriptor.interactionRange)
            pointer.pointee.color = pdescriptor.color
            pointer.pointee.frame = pdescriptor.frame
            pointer.pointee.speed = pdescriptor.speed + .random(in: pdescriptor.speedRange)
            pointer.pointee.speedY = pdescriptor.speedY
            pointer = pointer.advanced(by: 1)
        }
        currentParticles += birthRate
    }
    
    //load textute
    static func loadTexture(imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        var texture: MTLTexture?
        let textureLoaderOptions: [MTKTextureLoader.Option : Any]
        
        textureLoaderOptions = [.origin: MTKTextureLoader.Origin.bottomLeft, .SRGB: false]
        do {
            let fileExtension: String? = URL(fileURLWithPath: imageName).pathExtension.count == 0 ? "png" : nil
            if let url: URL = Bundle.main.url(forResource: imageName, withExtension: fileExtension) {
                texture = try textureLoader.newTexture(URL: url, options: textureLoaderOptions)
            } else {
                print("[ParticleSetup] Failed load \(imageName)")
            }
        } catch let error {
            print("[ParticleSetup] ",error.localizedDescription)
        }
        
        return texture
    }
    
    static func loadTextureImage(image: UIImage) -> MTLTexture {
        //CGImage変換時に向きがおかしくならないように
        UIGraphicsBeginImageContext(image.size);
        image.draw(in: CGRect(x:0, y:0, width:image.size.width, height:image.size.height))
        let orientationImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //CGImageに変換
        guard let cgImage = orientationImage?.cgImage else {
            fatalError("Can't open image \(image)")
        }
        //MTKTextureLoaderを使用してCGImageをMTLTextureに変換
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        do {
            let tex = try textureLoader.newTexture(cgImage: cgImage, options: nil)
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: tex.pixelFormat, width: tex.width, height: tex.height, mipmapped: false)
            textureDescriptor.usage = [.shaderRead, .shaderWrite]
            return tex
        }
        catch {
            fatalError("Can't load texture")
        }
    }
}
