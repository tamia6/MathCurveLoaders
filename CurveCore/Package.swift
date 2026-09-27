// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CurveCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "CurveCore", targets: ["CurveCore"]),
        .executable(name: "CurveCoreCheck", targets: ["CurveCoreCheck"]),
    ],
    targets: [
        .target(name: "CurveCore"),
        .executableTarget(name: "CurveCoreCheck", dependencies: ["CurveCore"], path: "Checks"),
    ]
)
