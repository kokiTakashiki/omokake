//
//  CreateParts.swift
//  omokake02
//
//  Created by takasiki on 10/13/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

//import Foundation
import CoreGraphics
import Metal
import simd

extension Renderer {
    func omokake(size: CGSize, texture: MTLTexture, colorCount: Int) -> ParticleSetup {
        //print("koko",self.partsCount!)
        //判定用
        let partsCount = self.partsCount!
        
        let particleSetup = ParticleSetup()
        //particleSetup.particleCount = 10000
        particleSetup.particleTexture = texture//ParticleSetup.loadTexture(imageName: selectKakera[0])
        particleSetup.birthRate = 1
        
        var particleDiscripter = ParticleDescriptor()
        //方向
        particleDiscripter.direction = -.pi / 2
        //particleDiscripter.directionRange = -1.0...1.0
        particleDiscripter.directionRange = 0.0...0.0
        //大きさ
        //particleDiscripter.pointSize = 10 //100 //10 //20
        //speed
        particleDiscripter.speed = 0.5
        particleDiscripter.speedRange = -1.18...0.12
        switch partsCount {
        case 1...50:
            //50
            particleDiscripter.pointSize = 100
            particleDiscripter.speedY = 3
        case 51...100:
            //
            particleDiscripter.pointSize = 70
            particleDiscripter.speedY = 2.5
        case 101...500:
            //
            particleDiscripter.pointSize = 40
            particleDiscripter.speedY = 1.3
        case 501...1000:
            //
            particleDiscripter.pointSize = 25
            particleDiscripter.speedY = 1.3
        case 1001...2000:
            //
            particleDiscripter.pointSize = 18
            particleDiscripter.speedY = 1.3
        case 2001...3000:
            //
            particleDiscripter.pointSize = 15
            particleDiscripter.speedY = 1.3
        case 3001...6000:
            //
            particleDiscripter.pointSize = 13
            particleDiscripter.speedY = 1.3
        case 6001...50000:
            //
            particleDiscripter.pointSize = 10
            particleDiscripter.speedY = 1
        case 50001...400000:
            //
            particleDiscripter.pointSize = 5
            particleDiscripter.speedY = 0.6
        default:
            break
        }
        switch colorCount {
        case 0:
            particleDiscripter.color = float4(1.0,1.0,1.0,1.0)
        case 1:
            particleDiscripter.color = float4(1.0,0.5,0.0,1.0)//orenge
        case 2:
            particleDiscripter.color = float4(0.4,1.0,1.0,1.0)//sian
        case 3:
            particleDiscripter.color = float4(1.0,0.1,0.8,1.0)//pink
        case 4:
            particleDiscripter.color = float4(0.4,1.0,0.1,1.0)//green
        default:
            break
        }
        //particleDiscripter.color = float4(1.0,0.1,0.8,1.0)
        //画面サイズ
        particleDiscripter.frame = float2(Float(size.width),Float(size.height))
        //print(float2(Float(size.width),Float(size.height)))
        //start地点
        particleDiscripter.startPosition = float2(0.0,0.0)
        
        particleSetup.particleDescriptor = particleDiscripter
        
        return particleSetup
    }
    
    func omokake2(size: CGSize, texture: MTLTexture, colorCount: Int) -> ParticleSetup {
        //判定用
        let partsCount = self.partsCount!
        
        let particleSetup = ParticleSetup()
        //particleSetup.particleCount = 10000
        particleSetup.particleTexture = texture//ParticleSetup.loadTexture(imageName: selectKakera[1])
        particleSetup.birthRate = 1
        
        var particleDiscripter = ParticleDescriptor()
        //方向
        particleDiscripter.direction = -.pi / 2
        //particleDiscripter.directionRange = -1.0...1.0
        particleDiscripter.directionRange = 0.0...0.0
        //大きさ
        //particleDiscripter.pointSize = 10 //100 //10 //20
        switch partsCount {
        case 1...50:
            //50
            particleDiscripter.pointSize = 90
            particleDiscripter.speedY = 3
        case 51...100:
            //
            particleDiscripter.pointSize = 80
            particleDiscripter.speedY = 2.5
        case 101...500:
            //
            particleDiscripter.pointSize = 50
            particleDiscripter.speedY = 1.3
        case 501...1000:
            //
            particleDiscripter.pointSize = 30
            particleDiscripter.speedY = 1.3
        case 1001...2000:
            //
            particleDiscripter.pointSize = 22
            particleDiscripter.speedY = 1.3
        case 2001...3000:
            //
            particleDiscripter.pointSize = 20
            particleDiscripter.speedY = 1.3
        case 3001...6000:
            //
            particleDiscripter.pointSize = 15
            particleDiscripter.speedY = 1.3
        case 6001...50000:
            //
            particleDiscripter.pointSize = 11
            particleDiscripter.speedY = 1
        case 50001...100000:
            //
            particleDiscripter.pointSize = 7
            particleDiscripter.speedY = 0.8
        case 100001...400000:
            //
            particleDiscripter.pointSize = 0.1
            particleDiscripter.speedY = 0.7
        default:
            break
        }
        switch colorCount {
        case 0:
            particleDiscripter.color = float4(1.0,1.0,1.0,1.0)
        case 1:
            particleDiscripter.color = float4(1.0,0.5,0.0,1.0)//orenge
        case 2:
            particleDiscripter.color = float4(0.4,1.0,1.0,1.0)//sian
        case 3:
            particleDiscripter.color = float4(1.0,0.1,0.8,1.0)//pink
        case 4:
            particleDiscripter.color = float4(0.4,1.0,0.1,1.0)//green
        default:
            break
        }
        //particleDiscripter.color = float4(1.0,0.1,0.8,1.0)
        //画面サイズ
        particleDiscripter.frame = float2(Float(size.width),Float(size.height))
        //print(float2(Float(size.width),Float(size.height)))
        //start地点
        particleDiscripter.startPosition = float2(0.0,0.0)
        //speed
        particleDiscripter.speed = 0.3
        particleDiscripter.speedRange = -0.98...0.42
        
        particleSetup.particleDescriptor = particleDiscripter
        
        return particleSetup
    }
    
    func omokakeThumbnail(size: CGSize, texture: MTLTexture) -> ParticleSetup {
        let particleSetup = ParticleSetup()
        particleSetup.particleTexture = texture
        particleSetup.birthRate = 1
        
        var particleDiscripter = ParticleDescriptor()
        //方向
        particleDiscripter.direction = -.pi / 2
        particleDiscripter.directionRange = -3.0...3.0
        //大きさ
        particleDiscripter.pointSize = 100
        particleDiscripter.speedY = 2
        
        //speed
        particleDiscripter.speed = 1
        particleDiscripter.speedRange = -1.78...0.62

        particleDiscripter.color = float4(1.0,1.0,1.0,1.0)
        //画面サイズ
        particleDiscripter.frame = float2(Float(size.width),Float(size.height))
        //start地点
        particleDiscripter.startPosition = float2(0.0,0.0)
        
        particleSetup.particleDescriptor = particleDiscripter
        
        return particleSetup
    }
}
