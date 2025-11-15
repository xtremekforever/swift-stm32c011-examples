// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "joystick-mmio",
    products: [
        .library(name: "Application", type: .static, targets: ["Application"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-mmio", from: "0.1.1"),
        .package(url: "https://github.com/xtremekforever/swift-stm32c011",  branch: "main"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio"),
                .product(name: "STM32C011", package: "swift-stm32c011"),
            ]
        )
    ]
)
