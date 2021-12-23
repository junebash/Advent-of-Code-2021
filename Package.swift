// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Advent of Code 2021",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "AoC2021", targets: ["AoC2021"])
    ],
    dependencies: [
        .package(
            name: "swift-parsing",
            url: "https://github.com/pointfreeco/swift-parsing",
            from: "0.4.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "AoC2021",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing")
            ]
        ),
    ]

)
