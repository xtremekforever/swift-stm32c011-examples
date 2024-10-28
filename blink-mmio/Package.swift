// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "blink-mmio",
    products: [
        .library(name: "Application", type: .static, targets: ["Application"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-mmio", branch: "swift-embedded-examples"),
        .package(url: "https://github.com/xtremekforever/swift-cortex-m", branch: "main"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio"),
                .product(name: "CortexM", package: "swift-cortex-m"),
                "Support",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
            ]
        ),
        .target(name: "Support"),
    ]
)
