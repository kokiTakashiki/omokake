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
@MainActor
protocol KakerasRendererProtocol: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    func draw(in view: MTKView)
}

let kMaxFramesInFlight = 3

@available(iOS 26.0, macOS 26.0, *)
final class KakerasRenderer: NSObject, KakerasRendererProtocol {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        resources.viewportSize.x = simd_uint1(size.width)
        resources.viewportSize.y = simd_uint1(size.height)
        updateViewportSizeBuffer()
    }

    func draw(in view: MTKView) {}

    private let device: MTLDevice
    private var defaultLibrary: MTLLibrary
    private let commandQueue: MTL4CommandQueue
    private let commandBuffer: MTL4CommandBuffer

    private var resources: KakerasRendererResources

    private var compiler: MTL4Compiler!
    private var computePipelineState: MTLComputePipelineState!
    private var threadgroupSize: MTLSize!
    private var threadgroupCount: MTLSize!

    private var renderPipelineState: MTLRenderPipelineState!

    init(with view: MTKView) {
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

        resources = KakerasRendererResources(with: view, device: device, commandQueue: commandQueue)
        super.init()
        updateViewportSizeBuffer()

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
        memcpy(
            resources.viewportSizeBuffer.contents(),
            &resources.viewportSize,
            MemoryLayout.size(ofValue: resources.viewportSize)
        )
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
        threadgroupCount.width = resources.compositeColorTexture.width + threadgroupSize.width - 1
        threadgroupCount.width /= threadgroupSize.width

        threadgroupCount.height = resources.compositeColorTexture.height + threadgroupSize.height - 1
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
