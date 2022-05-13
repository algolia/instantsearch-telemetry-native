// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstantSearchTelemetry",
    products: [
        .library(
            name: "InstantSearchTelemetry",
            targets: ["InstantSearchTelemetry"]),
    ],
    dependencies: [
      .package(name: "SwiftProtobuf",
               url: "https://github.com/apple/swift-protobuf.git",
               .revision("b9ec2c47e74f6bcf00af27772818ee034a6c6c25")),
      .package(name: "Gzip",
               url: "https://github.com/1024jp/GzipSwift",
               from: "5.2.0")
    ],
    targets: [
        .target(
            name: "InstantSearchTelemetry",
            dependencies: ["SwiftProtobuf", "Gzip"]),
        .testTarget(
            name: "InstantSearchTelemetryTests",
            dependencies: ["InstantSearchTelemetry"]),
    ]
)
