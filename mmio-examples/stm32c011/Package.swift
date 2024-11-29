// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "common-mmio",
    products: [
        .library(name: "STM32C011", targets: ["Common", "Support"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-mmio", branch: "swift-embedded-examples")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio"),
                "Support",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded")
            ]
        ),
        .target(name: "Support"),
    ]
)
