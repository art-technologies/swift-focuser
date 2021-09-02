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
            targets: ["Focuser"]),
    ],
    dependencies: [
        .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.3")
    ],
    targets: [
        .target(
            name: "Focuser",
            dependencies: ["Introspect"]),
        .testTarget(
            name: "FocuserTests",
            dependencies: ["Focuser"]),
    ]
)
