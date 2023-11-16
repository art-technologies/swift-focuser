// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Focuser",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Focuser",
            targets: ["Focuser"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", .upToNextMajor(from: "1.1.1")),
    ],
    targets: [
        .target(
            name: "Focuser",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "FocuserTests",
            dependencies: ["Focuser"],
            path: "Tests"
        ),
    ]
)
