# Math Curve Loaders

A native SwiftUI gallery of 33 animated mathematical curves, backed by the reusable, dependency-free `CurveCore` Swift package. The app offers English and Chinese through a persistent switch above the gallery.

原生 SwiftUI 数学曲线图库，包含 33 种动画曲线；应用内可切换中文和英文。`CurveCore` 是可供其他项目直接引用的 Swift Package。

## Platforms

- iOS and iPadOS 17.0 or later
- macOS 14.0 or later
- Xcode project target: `MathCurveLoaders`

## Run the app

Open the project in Xcode, choose the `MathCurveLoaders` scheme, select a macOS or iOS/iPadOS destination, then run it.

```sh
open MathCurveLoaders.xcodeproj
```

For a macOS build and launch from the terminal:

```sh
./script/build_and_run.sh
```

The script also supports `--debug`, `--logs`, `--telemetry`, and `--verify`.

## Verify

Run these commands from the repository root:

```sh
(cd CurveCore && swift run CurveCoreCheck)
xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
./script/build_and_run.sh --verify
```

## Curve IDs

Original reference set: `originalThinking`, `thinkingFive`, `thinkingNine`, `roseOrbit`, `roseCurve`, `roseTwo`, `roseThree`, `roseFour`, `lissajousDrift`, `lemniscateBloom`, `hypotrochoidLoop`, `threePetalSpiral`, `fourPetalSpiral`, `fivePetalSpiral`, `sixPetalSpiral`, `butterflyPhase`, `cardioidGlow`, `cardioidHeart`, `heartWave`, `spiralSearch`, `fourierFlow`.

Additional curves: `epicycloid`, `hypocycloid`, `starTrochoid`, `archimedeanSpiral`, `logarithmicSpiral`, `superellipse`, `lissajousKnot`, `harmonograph`, `fourierDrawing`. The existing `butterflyPhase` is the butterfly curve from the reference set.

Physics curves: `magneticHelix`, `doublePendulum`, `lorenzAttractor`. The helix uses an oblique 2D projection; double pendulum and Lorenz paths are numerically integrated once and interpolated during animation. Lorenz is a state-space trajectory, not a particle path.

## Reuse CurveCore

Add the local package to another Swift package during development:

```swift
.package(path: "../MathCurveLoaders/CurveCore")
```

Remote reuse requires pushing this repository, then replacing the local path with its Git URL and a version or revision requirement.

```swift
.package(url: "https://example.com/your-org/MathCurveLoaders.git", from: "1.0.0")
```

`CurveCore` exposes curve definitions, sampling, and `CurveAnimationView`. Its metadata supports `definition.title(in: .chinese)` and `definition.summary(in: .english)`; curve IDs and mathematical equations stay language independent. The gallery app remains separate from that public package boundary.

## Source reference

The initial 21 formulas were independently implemented using [Paidax01/math-curve-loaders](https://github.com/Paidax01/math-curve-loaders) as a reference catalog. The additional twelve curves use standard mathematical and physics parameterizations. This repository does not copy the reference source.
