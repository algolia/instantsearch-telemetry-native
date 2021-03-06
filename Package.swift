// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstantSearchTelemetry",
    platforms: [
      .iOS(.v9),
      .macOS(.v10_11),
      .watchOS(.v2),
      .tvOS(.v9)
    ],
    products: [
        .library(
            name: "InstantSearchTelemetry",
            targets: ["InstantSearchTelemetry"]),
        .executable(
          name: "Parser",
          targets: ["TelemetryParser"])
    ],
    dependencies: [
      .package(name: "SwiftProtobuf",
               url: "https://github.com/apple/swift-protobuf.git",
               from: "1.19.0"),
      .package(name: "swift-argument-parser",
               url: "https://github.com/apple/swift-argument-parser",
               from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "InstantSearchTelemetry",
            dependencies: ["SwiftProtobuf"]),
        .executableTarget(
            name: "TelemetryParser",
            dependencies: [
              .product(name: "SwiftProtobuf",
                       package: "SwiftProtobuf"),
              .product(name: "ArgumentParser",
                       package: "swift-argument-parser"),
              .targetItem(name: "InstantSearchTelemetry",
                          condition: .none)
            ]),
        .testTarget(
            name: "InstantSearchTelemetryTests",
            dependencies: ["InstantSearchTelemetry", "TelemetryParser"]),
    ]
)
