// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "blink-mmio",
    products: [
        .library(name: "Application", type: .static, targets: ["Application"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-mmio", branch: "swift-embedded-examples")
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio"),
                "Support",
            ]
        ),
        .target(name: "Support"),
    ]
)
