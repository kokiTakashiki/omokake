// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OmokakeWindowApp",
    platforms: [
        // iOS13を指定しているが実際はiOS26以降が対象のライブラリ
        // OmokakeがiOS13以降をサポートしているのでimportできるようにiOS13を指定している。
        .iOS(.v13),
        .macOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OmokakeWindowApp",
            targets: ["OmokakeWindowApp"]
        ),
    ],
    dependencies: [
        .package(path: "../OmokakeResources"),
        .package(path: "../OmokakeShaders")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OmokakeWindowApp",
            dependencies: [
                .product(name: "OmokakeResources", package: "OmokakeResources"),
                .product(name: "OmokakeShaders", package: "OmokakeShaders")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "OmokakeWindowAppTests",
            dependencies: ["OmokakeWindowApp"]
        ),
    ]
)
