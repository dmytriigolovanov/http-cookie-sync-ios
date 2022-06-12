// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTTPCookieSync",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "HTTPCookieSync",
            targets: ["HTTPCookieSync"]
        )
    ],
    targets: [
        .target(
            name: "HTTPCookieSync",
            path: "HTTPCookieSync/Sources"
        )
    ],
    swiftLanguageVersions: [.v5]
)
