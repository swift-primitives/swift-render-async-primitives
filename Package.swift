// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-render-async-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Render Async Primitives",
            targets: ["Render Async Primitives"]
        ),
        .library(
            name: "Render Async Primitives Test Support",
            targets: ["Render Async Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-render-primitives"),
        .package(path: "../swift-async-primitives"),
        .package(path: "../swift-byte-primitives"),
    ],
    targets: [
        .target(
            name: "Render Async Primitives",
            dependencies: [
                .product(name: "Render Primitives Core", package: "swift-render-primitives"),
                .product(name: "Async Channel Primitives", package: "swift-async-primitives"),
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
            ]
        ),
        .target(
            name: "Render Async Primitives Test Support",
            dependencies: [
                "Render Async Primitives",
                .product(name: "Render Primitives Test Support", package: "swift-render-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Render Async Primitives Tests",
            dependencies: [
                "Render Async Primitives",
                "Render Async Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
