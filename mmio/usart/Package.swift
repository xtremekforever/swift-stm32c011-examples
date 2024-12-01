// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "usart-mmio",
    products: [
        .library(name: "Application", type: .static, targets: ["Application"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-mmio", branch: "swift-embedded-examples"),
        .package(url: "https://github.com/xtremekforever/swift-stm32c011", branch: "main"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio"),
                .product(name: "STM32C011", package: "swift-stm32c011"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded")
            ]
        )
    ]
)
