//
//  KakerasRendererResources.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/24.
//

import MetalKit
import OmokakeShaders
import simd

enum KakerasRendererResourcesError: Error {
    case createTGAImageFailed
    case makeTextureFailed
}

@MainActor
struct KakerasRendererResources {
    let vertexDataBuffer: MTLBuffer
    var viewportSize: simd_uint2
    let viewportSizeBuffer: MTLBuffer

    let backgroundImageTexture: MTLTexture
    let chyronTexture: MTLTexture
    let compositeColorTexture: MTLTexture
    let compositeGrayscaleTexture: MTLTexture

    let argumentTable: MTL4ArgumentTable
    let sharedEvent: MTLSharedEvent
    let frameNumber: UInt64 = 0

    let residencySet: MTLResidencySet
    let commandAllocators: [MTL4CommandAllocator]

    init(with view: MTKView, device: MTLDevice, commandQueue: MTL4CommandQueue) {
        viewportSize = simd_uint2(UInt32(view.drawableSize.width), UInt32(view.drawableSize.height))

        // Create the app's resources.
        // Create the buffer that stores the vertex data.
        guard let vertexDataBuffer = device.makeBuffer(
            length: MemoryLayout.size(ofValue: triangleVertexData),
            options: .storageModeShared
        ) else {
            fatalError("error making vertexDataBuffer")
        }
        self.vertexDataBuffer = vertexDataBuffer
        memcpy(self.vertexDataBuffer.contents(), triangleVertexData, MemoryLayout.size(ofValue: triangleVertexData))
        // Create the buffer that stores the app's viewport data.
        guard let viewportSizeBuffer = device.makeBuffer(
            length: MemoryLayout.size(ofValue: viewportSize),
            options: .storageModeShared
        ) else {
            fatalError("error making viewportSizeBuffer")
        }
        self.viewportSizeBuffer = viewportSizeBuffer

        // MARK: createTextures

        let chyronImageFileName = "Aloha-chyron"
        let backgroundImageFileName = "Hawaii-coastline"
        guard let backgroundImageFile = Bundle.module.url(forResource: backgroundImageFileName, withExtension: "tga")
        else {
            fatalError("error loading backgroundImageFileName from bundle")
        }
        do {
            backgroundImageTexture = try Self.loadImage(for: backgroundImageFile, device: device)
        } catch {
            fatalError("error loading backgroundImageTexture: \(error)")
        }
        guard let chyronImageFile = Bundle.module.url(forResource: chyronImageFileName, withExtension: "tga") else {
            fatalError("error loading chyronImageFile from bundle")
        }
        do {
            chyronTexture = try Self.loadImage(for: chyronImageFile, device: device)
        } catch {
            fatalError("error loading chyronTexture: \(error)")
        }
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.textureType = .type2D
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.width = backgroundImageTexture.width
        textureDescriptor.height = backgroundImageTexture.height + chyronTexture.height
        textureDescriptor.usage = .shaderRead

        guard let compositeColorTexture = device.makeTexture(descriptor: textureDescriptor) else {
            fatalError("error making compositeColorTexture")
        }
        self.compositeColorTexture = compositeColorTexture

        textureDescriptor.usage = [.shaderWrite, .shaderRead]
        guard let compositeGrayscaleTexture = device.makeTexture(descriptor: textureDescriptor) else {
            fatalError("error making compositeGrayscaleTexture")
        }
        self.compositeGrayscaleTexture = compositeGrayscaleTexture

        // MARK: Create the types that manage the resources.

        let descriptor = MTL4ArgumentTableDescriptor()
        descriptor.maxTextureBindCount = 2
        descriptor.maxBufferBindCount = 2
        do {
            argumentTable = try device.makeArgumentTable(descriptor: descriptor)
        } catch {
            fatalError("error makeArgumentTable: \(error)")
        }

        guard let sharedEvent = device.makeSharedEvent() else {
            fatalError("error making sharedEvent")
        }
        self.sharedEvent = sharedEvent
        self.sharedEvent.signaledValue = frameNumber

        let residencySetDescriptor = MTLResidencySetDescriptor()
        do {
            residencySet = try device.makeResidencySet(descriptor: residencySetDescriptor)
        } catch {
            fatalError("The device can't create a residency set due to: \(error)")
        }
        commandQueue.addResidencySet(residencySet)
        residencySet.addAllocations([
            backgroundImageTexture,
            chyronTexture,
            compositeColorTexture,
            compositeGrayscaleTexture,
            vertexDataBuffer,
            viewportSizeBuffer,
        ])
        residencySet.commit()

        var result = [MTL4CommandAllocator]()
        for _ in 0 ..< kMaxFramesInFlight {
            guard let allocator = device.makeCommandAllocator() else {
                fatalError("The device can't create an allocator set due to")
            }
            result.append(allocator)
        }
        commandAllocators = result
    }

    private let triangleVertexData: [VertexData] = [
        // The 1st triangle of the rectangle for the composite color texture.
        .init(position: .init(x: 480, y: 40), textureCoordinate: .init(x: 1, y: 1)),
        .init(position: .init(x: -480, y: 40), textureCoordinate: .init(x: 0, y: 1)),
        .init(position: .init(x: -480, y: 720), textureCoordinate: .init(x: 0, y: 0)),

        // The 2nd triangle of the rectangle for the composite color texture.
        .init(position: .init(x: 480, y: 40), textureCoordinate: .init(x: 1, y: 1)),
        .init(position: .init(x: -480, y: 720), textureCoordinate: .init(x: 0, y: 0)),
        .init(position: .init(x: 480, y: 720), textureCoordinate: .init(x: 1, y: 0)),

        // The 1st triangle of the rectangle for the composite grayscale texture.
        .init(position: .init(x: 480, y: -720), textureCoordinate: .init(x: 1, y: 1)),
        .init(position: .init(x: -480, y: -720), textureCoordinate: .init(x: 0, y: 1)),
        .init(position: .init(x: -480, y: -40), textureCoordinate: .init(x: 0, y: 0)),

        // The 2nd triangle of the rectangle for the composite grayscale texture.
        .init(position: .init(x: 480, y: -720), textureCoordinate: .init(x: 1, y: 1)),
        .init(position: .init(x: -480, y: -40), textureCoordinate: .init(x: 0, y: 0)),
        .init(position: .init(x: 480, y: -40), textureCoordinate: .init(x: 1, y: 0)),
    ]

    private static func loadImage(for imageFileLocation: URL, device: MTLDevice) throws -> MTLTexture {
        guard let image = try TGAImage(with: imageFileLocation) else {
            throw KakerasRendererResourcesError.createTGAImageFailed
        }
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.textureType = .type2D
        textureDescriptor.usage = .shaderRead
        textureDescriptor.width = image.width
        textureDescriptor.height = image.height
        guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
            throw KakerasRendererResourcesError.makeTextureFailed
        }
        let size = MTLSize(width: textureDescriptor.width, height: textureDescriptor.height, depth: 1)
        let region = MTLRegion(origin: .init(x: 0, y: 0, z: 0), size: size)
        let bytesPerRow = 4 * textureDescriptor.width
        image.data.withUnsafeBytes { bytes in
            guard let bytesAddress = bytes.baseAddress else {
                fatalError("load BytesAddress From TGAFile Failed")
            }
            texture.replace(
                region: region,
                mipmapLevel: 0,
                withBytes: bytesAddress,
                bytesPerRow: bytesPerRow
            )
        }
        return texture
    }
}
