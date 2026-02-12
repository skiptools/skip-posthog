// swift-tools-version: 5.9
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
    name: "skip-posthog",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SkipPostHog", targets: ["SkipPostHog"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
        .package(url: "https://github.com/PostHog/posthog-ios.git", from: "3.0.0")

    ],
    targets: [
        .target(name: "SkipPostHog", dependencies: [
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "PostHog", package: "posthog-ios", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .macCatalyst]))
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipPostHogTests", dependencies: [
            "SkipPostHog",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

if Context.environment["SKIP_BRIDGE"] ?? "0" != "0" {
    package.dependencies += [.package(url: "https://source.skip.tools/skip-bridge.git", "0.0.0"..<"2.0.0")]
    package.targets.forEach({ target in
        target.dependencies += [.product(name: "SkipBridge", package: "skip-bridge")]
    })
    // all library types must be dynamic to support bridging
    package.products = package.products.map({ product in
        guard let libraryProduct = product as? Product.Library else { return product }
        return .library(name: libraryProduct.name, type: .dynamic, targets: libraryProduct.targets)
    })
}

