// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "motiontag_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "motiontag-sdk", targets: ["motiontag_sdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/MOTIONTAG/motiontag-sdk-ios-releases.git", exact: "7.0.0")
    ],
    targets: [
        .target(
            name: "motiontag_sdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "MotionTagSDK", package: "motiontag-sdk-ios-releases")
            ]
        )
    ]
)
