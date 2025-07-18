// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShowcaseSocialAppServer",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/httpswift/swifter.git", from: "1.5.0"),
        .package(url: "https://github.com/Kitura/Swift-JWT.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ShowcaseSocialAppServer",
            dependencies: [
                .product(name: "Swifter", package: "swifter"),
                .product(name: "SwiftJWT", package: "Swift-JWT")
            ],
            resources: [
                .copy("Swagger/swagger-ui.html"),
                .copy("Swagger/swagger.yaml"),
                .copy("Data"),
                .copy("Uploads")
            ]
        ),
    ]
)
