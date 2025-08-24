//
//  KakerasRenderer.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/19.
//

import MetalKit
import OmokakeShaders
import simd

@available(iOS 26.0, macOS 26.0, *)
protocol KakerasRendererProtocol: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    func draw(in view: MTKView)
}

let kMaxFramesInFlight = 3

@available(iOS 26.0, macOS 26.0, *)
final class KakerasRenderer: NSObject, KakerasRendererProtocol {
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

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize.x = simd_uint1(size.width)
        viewportSize.y = simd_uint1(size.height)
        updateViewportSizeBuffer()
    }

    func draw(in view: MTKView) {}

    private let device: MTLDevice
    private var defaultLibrary: MTLLibrary
    private let commandQueue: MTL4CommandQueue
    private let commandBuffer: MTL4CommandBuffer
    private let vertexDataBuffer: MTLBuffer
    private var viewportSize: simd_uint2
    private let viewportSizeBuffer: MTLBuffer

    private var backgroundImageTexture: MTLTexture!
    private var chyronTexture: MTLTexture!
    private var compositeColorTexture: MTLTexture!
    private var compositeGrayscaleTexture: MTLTexture!

    private var argumentTable: MTL4ArgumentTable!
    private var sharedEvent: MTLSharedEvent!
    private let frameNumber: UInt64 = 0

    private var residencySet: MTLResidencySet!
    private var commandAllocators: [MTL4CommandAllocator]!

    private var compiler: MTL4Compiler!

    private var computePipelineState: MTLComputePipelineState!

    private var threadgroupSize: MTLSize!
    private var threadgroupCount: MTLSize!

    private var renderPipelineState: MTLRenderPipelineState!

    @MainActor
    init(with view: MTKView) {
        viewportSize = simd_uint2(UInt32(view.drawableSize.width), UInt32(view.drawableSize.height))

        guard let device = view.device else {
            fatalError("must have a device")
        }
        self.device = device

        guard let commandQueue = device.makeMTL4CommandQueue() else {
            fatalError("error making commandQueue")
        }
        self.commandQueue = commandQueue

        guard let commandBuffer = device.makeCommandBuffer() else {
            fatalError("error making commandBuffer")
        }
        self.commandBuffer = commandBuffer

        do {
            let library = try device.makeDefaultLibrary(bundle: OmokakeShaders().bundle)
            defaultLibrary = library
        } catch {
            fatalError("error making defaultLibrary \(error)")
        }

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
        super.init()
        updateViewportSizeBuffer()
        createTextures()

        // Create the types that manage the resources.
        createArgumentTable()
        createSharedEvent()
        createResidencySets()

        // Add the Metal layer's residency set to the queue.
        guard let metalLayer = view.layer as? CAMetalLayer else {
            fatalError("Failed to cast view.layer to CAMetalLayer")
        }
        commandQueue.addResidencySet(metalLayer.residencySet)

        // Create the compute pipeline.
        createCompiler()
        createComputePipeline()
        configureThreadgroupForComputePasses()

        let pixelFormat: MTLPixelFormat = .bgra8Unorm_srgb
        view.colorPixelFormat = pixelFormat
        createRenderPipeline(for: pixelFormat)
    }

    private func updateViewportSizeBuffer() {
        memcpy(viewportSizeBuffer.contents(), &viewportSize, MemoryLayout.size(ofValue: viewportSize))
    }

    private func createTextures() {
        let chyronImageFileName = "Aloha-chyron"
        let backgroundImageFileName = "Hawaii-coastline"
        let backgroundImageFile = Bundle.module.url(forResource: backgroundImageFileName, withExtension: "tga")!
        do {
            backgroundImageTexture = try loadImage(for: backgroundImageFile)
        } catch {
            fatalError("error loading backgroundImageTexture: \(error)")
        }
        let chyronImageFile = Bundle.module.url(forResource: chyronImageFileName, withExtension: "tga")!
        do {
            chyronTexture = try loadImage(for: chyronImageFile)
        } catch {
            fatalError("error loading chyronTexture: \(error)")
        }
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.textureType = .type2D
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.width = backgroundImageTexture!.width
        textureDescriptor.height = backgroundImageTexture!.height + chyronTexture!.height
        textureDescriptor.usage = .shaderRead

        compositeColorTexture = device.makeTexture(descriptor: textureDescriptor)
        assert(compositeColorTexture != nil)

        textureDescriptor.usage = [.shaderWrite, .shaderRead]
        compositeGrayscaleTexture = device.makeTexture(descriptor: textureDescriptor)
        assert(compositeGrayscaleTexture != nil)
    }

    private func loadImage(for imageFileLocation: URL) throws -> MTLTexture? {
        guard let image = try TGAImage(with: imageFileLocation) else {
            return nil
        }
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.textureType = .type2D
        textureDescriptor.usage = .shaderRead
        textureDescriptor.width = image.width
        textureDescriptor.height = image.height
        guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
            return nil
        }
        let size = MTLSize(width: textureDescriptor.width, height: textureDescriptor.height, depth: 1)
        let region = MTLRegion(origin: .init(x: 0, y: 0, z: 0), size: size)
        let bytesPerRow = 4 * textureDescriptor.width
        image.data.withUnsafeBytes { bytes in
            texture.replace(
                region: region,
                mipmapLevel: 0,
                withBytes: bytes.baseAddress!,
                bytesPerRow: bytesPerRow
            )
        }
        return texture
    }

    private func createArgumentTable() {
        let descriptor = MTL4ArgumentTableDescriptor()
        descriptor.maxTextureBindCount = 2
        descriptor.maxBufferBindCount = 2
        argumentTable = try? device.makeArgumentTable(descriptor: descriptor)
        assert(argumentTable != nil)
    }

    private func createSharedEvent() {
        sharedEvent = device.makeSharedEvent()
        sharedEvent.signaledValue = frameNumber
    }

    private func createResidencySets() {
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
        for i in 0 ..< kMaxFramesInFlight {
            guard let allocator = device.makeCommandAllocator() else {
                fatalError("The device can't create an allocator set due to")
            }
            result.append(allocator)
        }
        commandAllocators = result
    }

    private func createCompiler() {
        let compilerDescriptor = MTL4CompilerDescriptor()
        do {
            compiler = try device.makeCompiler(descriptor: compilerDescriptor)
        } catch {
            fatalError("The device can't create a compiler due to: \(error)")
        }
    }

    private func createComputePipeline() {
        let kernelFunction = MTL4LibraryFunctionDescriptor()
        kernelFunction.library = defaultLibrary
        kernelFunction.name = "convertToGrayscale"
        let pipelineDescriptor = MTL4ComputePipelineDescriptor()
        pipelineDescriptor.computeFunctionDescriptor = kernelFunction

        do {
            computePipelineState = try compiler.makeComputePipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("The compiler can't create a compute pipeline with kernel function: \(error)")
        }
    }

    private func configureThreadgroupForComputePasses() {
        threadgroupSize = MTLSizeMake(16, 16, 1)
        threadgroupCount = .init()
        threadgroupCount.width = compositeColorTexture.width + threadgroupSize.width - 1
        threadgroupCount.width /= threadgroupSize.width

        threadgroupCount.height = compositeColorTexture.height + threadgroupSize.height - 1
        threadgroupCount.height /= threadgroupSize.height

        threadgroupCount.depth = 1
    }

    private func createRenderPipeline(for pixelFormat: MTLPixelFormat) {
        let vertexFunction = MTL4LibraryFunctionDescriptor()
        vertexFunction.library = defaultLibrary
        vertexFunction.name = "vertexShader"

        let fragmentFunction = MTL4LibraryFunctionDescriptor()
        fragmentFunction.library = defaultLibrary
        fragmentFunction.name = "samplingShader"

        let pipelineDescriptor = MTL4RenderPipelineDescriptor()
        pipelineDescriptor.label = "Simple Render Pipeline"
        pipelineDescriptor.vertexFunctionDescriptor = vertexFunction
        pipelineDescriptor.fragmentFunctionDescriptor = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat

        do {
            renderPipelineState = try compiler.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("The compiler can't create a render pipeline due to: \(error)")
        }
    }
}
