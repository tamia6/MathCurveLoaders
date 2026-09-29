# Math Curve Loaders

A native SwiftUI gallery of 91 animated mathematical curves, backed by the reusable, dependency-free `CurveCore` Swift package. The app offers English and Chinese through a persistent globe menu in the sidebar toolbar.

原生 SwiftUI 数学曲线图库，包含 91 种动画曲线；应用内可切换中文和英文。`CurveCore` 是可供其他项目直接引用的 Swift Package。

The gallery groups curves by square, horizontal, and vertical layout. Square curves are subdivided into flowers and orbits, rolling curves and cusps, spirals and growth, traces and outlines, and physics and motion; search keeps matching curves in their groups. 图库按方形、横向和竖向分组；方形曲线继续按花瓣与轨道、滚线与尖点、螺旋与生长、轨迹与轮廓、物理与运动细分，搜索结果仍保留所属分组。

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

Additional square curves: `deltoid`, `nephroid`, `heptagonalHypocycloid`, `fourierRosette`, `lissajousOrbit`, `orbitalPrecession`. These remain in the square gallery group and use the same reusable sampling API.

Advanced square curves: `cassiniOval`, `gielisBloom`, `maurerRose`, `eulerSpiral`, `goldenAngleSpiral`, `pursuitPolygon`. The gallery groups these by visual family while `CurveCore` keeps their IDs and sampling APIs language independent.

Further square curves: `fermatSpiral`, `lituusSpiral`, `fourierTrefoil`, `interferenceRing`, `chladniRing`, `higherOrderRose`. These extend the existing square shape groups with inverse-root spirals, harmonic knot traces, wave-driven rings, and a higher-order rose.

More square outlines: `bicorn`, `cochleoid`, `nicomedesConchoid`, `superformulaHexagon`. Each uses `aspectRatio == 1` and the existing bilingual catalog and sampling APIs.

Latest square curves: `piriform`, `descartesFolium`, `innerLoopLimacon`, `rightStrophoid`. These add a pear outline, diagonal leaf loop, nested polar loop, and side-facing strophoid loop to the existing square groups.

Expanded square set (20): `circleInvolute`, `hyperbolicSpiral`, `cissoidOfDiocles`, `witchOfAgnesi`, `tractrix`, `serpentineCurve`, `cycloidArch`, `tschirnhausenCubic`, `superformulaTriangle`, `harmonicStar`, `rippleSpiral`, `chirpedSpiral`, `tenToothSprocket`, `moireRosette`, `asymmetricOrbit`, `polarDaisy`, `beatOrbit`, `dampedPhasePortrait`, `drivenOscillator`, `dipoleFieldLine`. The first eight use classical named equations; the remaining twelve are explicit parametric compositions. All retain `aspectRatio == 1`, English and Chinese metadata, and the public `CurveSampler` API.

Physics curves: `magneticHelix`, `doublePendulum`, `lorenzAttractor`. The helix uses an oblique 2D projection; double pendulum and Lorenz paths are numerically integrated once and interpolated during animation. Lorenz is a state-space trajectory, not a particle path.

Directional curves: `horizontalTravelingWave`, `horizontalStandingWave`, `horizontalDampedWave`, `horizontalChirpWave`, `horizontalWavePacket`, `horizontalSolitaryPulse`, `verticalTravelingWave`, `verticalSpring`, `verticalDoubleHelix`, `verticalSCurve`, `verticalDampedWave`, `verticalCatenary`. Each definition exposes `aspectRatio` (`3` for horizontal, `1/3` for vertical). Use it when sizing `CurveAnimationView` in another SwiftUI app; `CurveSampler.samples` accepts elapsed seconds and returns normalized animated points.

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

For horizontal and vertical curves, size the view using the definition's ratio:

```swift
import CurveCore
import SwiftUI

if let curve = CurveCatalog.definition(for: .horizontalTravelingWave) {
    CurveAnimationView(definition: curve, parameters: curve.defaultParameters)
        .aspectRatio(curve.aspectRatio, contentMode: .fit)
}
```

## Source reference

The initial 21 formulas were independently implemented using [Paidax01/math-curve-loaders](https://github.com/Paidax01/math-curve-loaders) as a reference catalog. The additional seventy curves use mathematical and physics parameterizations. Named curves in the expanded square set were checked against [Wolfram MathWorld](https://mathworld.wolfram.com/), including its [circle involute](https://mathworld.wolfram.com/CircleInvolute.html), [cissoid](https://mathworld.wolfram.com/CissoidofDiocles.html), [tractrix](https://mathworld.wolfram.com/Tractrix.html), and [cycloid](https://mathworld.wolfram.com/Cycloid.html) references. This repository does not copy the reference source.
