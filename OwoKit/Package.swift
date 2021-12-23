// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OwoKit",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0"),
        .tvOS("15.0"),
        .watchOS("8.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "OwoKit",
            targets: ["OwoKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0"))
    ],
    targets: [
        .target(
            name: "OwoKit",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "OwoKitTests",
            dependencies: ["OwoKit"]),
    ]
)
