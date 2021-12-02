// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "instantsearch-telemetry-native",
    products: [
        .library(
            name: "Telemetry",
            targets: ["instantsearch-telemetry-native"]),
    ],
    dependencies: [
      .package(name: "SwiftProtobuf",
               url: "https://github.com/apple/swift-protobuf.git",
               from: "1.6.0"),
      .package(name: "Gzip",
               url: "https://github.com/1024jp/GzipSwift",
               from: "5.1.0")
    ],
    targets: [
        .target(
            name: "instantsearch-telemetry-native",
            dependencies: ["SwiftProtobuf", "Gzip"]),
        .testTarget(
            name: "instantsearch-telemetry-nativeTests",
            dependencies: ["instantsearch-telemetry-native"]),
    ]
)
