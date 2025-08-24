// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OmokakeShaders",
    platforms: [
        // iOS13を指定しているが実際はiOS26以降が対象のライブラリ
        // OmokakeがiOS13以降をサポートしているのでimportできるようにiOS13を指定している。
        .iOS(.v13),
        .macOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "OmokakeShaders",
            targets: ["OmokakeShaders"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/schwa/MetalCompilerPlugin", branch: "main")
    ],
    targets: [
        .target(
            name: "OmokakeShaders",
            resources: [
                .process("Metal/Shaders.metal")
            ],
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedFramework("MetalKit", .when(platforms: [.iOS, .macOS, .visionOS]))
            ],
            plugins: [
                .plugin(name: "MetalCompilerPlugin", package: "MetalCompilerPlugin")
            ]
        ),
        .testTarget(
            name: "OmokakeShadersTests",
            dependencies: ["OmokakeShaders"]
        ),
    ]
)
