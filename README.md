# Math Curve Loaders

[Live demo / 在线演示](https://tamia6.github.io/MathCurveLoaders/)

**Math-based loading animations for your apps.** Math Curve Loaders turns mathematical curves into 103 animated loading patterns. Preview a pattern, adjust its speed, trail, and appearance, then reuse it in loading states such as fetching data or processing a task.

**基于数学的 Loading 图案，为应用中的等待加入动画。** Math Curve Loaders 将数学曲线转化为 103 种加载动画。你可以预览图案、调整速度、拖尾和线条，再将它用于数据加载、请求等待或任务处理等场景。

The native SwiftUI app is a playground for choosing and tuning loading animations on iOS, iPadOS, and macOS. The dependency-free `CurveCore` Swift package provides reusable animation views and mathematical sampling APIs. The H5 demo in `web/` lets you try the same 103 patterns in a browser and copy standalone HTML, CSS, and JavaScript with your chosen parameters. Both demos support English and Chinese.

原生 SwiftUI 应用用于在 iOS、iPadOS 和 macOS 上挑选与调试 Loading 动画；无第三方依赖的 `CurveCore` Swift Package 提供可直接复用的动画视图和数学采样接口。`web/` 中的 H5 演示让你在浏览器中体验同一套 103 种图案，并复制带有当前参数的独立 HTML、CSS 和 JavaScript 代码。两种演示均支持中文和英文。

Loading patterns are grouped into square, horizontal, and vertical layouts to fit different loading areas. Square patterns are subdivided into flowers and orbits, rolling curves and cusps, spirals and growth, traces and outlines, and physics and motion. Each pattern includes its equation and bilingual description.

Loading 图案按方形、横向和竖向布局分组，便于适配不同的加载区域。方形图案进一步细分为花瓣与轨道、滚线与尖点、螺旋与生长、轨迹与轮廓、物理与运动。每种图案都附有数学公式和中英文说明。

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

## H5 demo / 网页演示

Use the browser demo to choose a loading pattern, preview parameter changes in real time, and copy a ready-to-use H5 snippet for your website.

网页演示用于挑选 Loading 图案、实时预览参数变化，并复制可直接粘贴到网页中使用的 H5 代码。

The desktop layout follows the macOS app: a searchable, grouped pattern grid with two cards per row on the left and a large preview, equation, and live controls on the right. Each pane scrolls independently. Narrow screens stack the pattern list above the detail view.

桌面布局与 macOS 应用保持一致：左侧以每排两个图案的网格展示，支持搜索和分类选择，右侧显示大预览、公式与实时参数控制，两侧独立滚动。窄屏下改为上方选图、下方预览与调参。

Click **Copy H5 code**, then paste the snippet into the body of an HTML page. The snippet embeds the selected curve samples, renderer, and current parameters; no dependencies, extra files, or network requests are needed. Repeat it for multiple independent loaders. Change the canvas inline width and height to resize it. In framework projects, mount the canvas and run the script through the framework lifecycle; inserting a script via `innerHTML` does not execute it.

点击 **复制 H5 代码**，将代码粘贴到 HTML 页面的 body 中即可运行。代码内嵌所选图案数据、绘制逻辑和当前参数，无需依赖、额外文件或网络请求；可重复粘贴多个独立动画。调整 canvas 的内联宽高即可改变尺寸。框架项目需在生命周期中挂载 canvas 并执行脚本，通过 `innerHTML` 插入的脚本不会自动执行。

Serve the static site from the repository root, then open `http://localhost:8765`:

```sh
python3 -m http.server 8765 --directory web
```

The website has no third-party dependencies or JavaScript build step. It loads curve data only when a preview is visible. Curve data is generated from `CurveCore`, using 48 shape phases and 480 path samples per curve (3,200 for the double pendulum and Lorenz paths). The browser interpolates neighboring phases and samples; this is an approximation of the native sampler. Playback respects reduced-motion preferences and pauses rendering in hidden tabs.

网页采用原生 Canvas，无第三方依赖，预览出现时才加载对应曲线。曲线数据来自 `CurveCore`；浏览器插值播放，因此网页形变是原生采样器的近似。页面遵循系统“减少动态效果”设置，后台标签页停止绘制。

After changing formulas, metadata, defaults, or gallery groups, regenerate the checked-in assets on macOS:

```sh
python3 script/export_web.py
node web/check.mjs
```

The [live demo](https://tamia6.github.io/MathCurveLoaders/) is deployed to GitHub Pages. `.github/workflows/pages.yml` publishes `web/` using GitHub Actions when site changes are pushed to `main`; it can also be run manually. For forks, enable **Settings → Pages → Source → GitHub Actions**. `web/site.json` stores the repository link shown in the page header.

[在线演示](https://tamia6.github.io/MathCurveLoaders/)已部署至 GitHub Pages。向 `main` 推送网页改动后会自动更新，也可手动运行部署工作流。

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

## Latest loading patterns / 最新 Loading 图案

This batch adds 12 closed paths with continuous loop seams: eight square patterns and four directional tracks. The catalog now contains 103 patterns (87 square, eight horizontal, eight vertical). All support bilingual descriptions, live parameters, and self-contained H5 copying.

本批新增 12 条闭合路径：8 个方形图案和 4 个横竖轨道，循环接缝处连续衔接。现有 103 种图案（方形 87、横向 8、竖向 8），均支持双语说明、实时调参和独立 H5 代码复制。

| 中文 / English | ID | 分类 / Group |
| --- | --- | --- |
| 呼吸圆环 / Breathing Ring | `breathingCircle` | 花瓣与轨道 / Flowers & Orbits |
| 豆形轨道 / Bean Orbit | `beanOrbit` | 花瓣与轨道 / Flowers & Orbits |
| 外旋轮花 / Epitrochoid Bloom | `epitrochoidBloom` | 滚线与尖点 / Rolling Curves & Cusps |
| 环面结投影 / Torus Knot Projection | `torusKnotProjection` | 轨迹与轮廓 / Traces & Outlines |
| 维维亚尼窗 / Viviani Window | `vivianiWindow` | 轨迹与轮廓 / Traces & Outlines |
| 马蹄椭圆 / Hippopede Oval | `hippopedeLoop` | 轨迹与轮廓 / Traces & Outlines |
| 谐波丝带 / Harmonic Ribbon | `harmonicRibbon` | 轨迹与轮廓 / Traces & Outlines |
| 圆润十字 / Rounded Cross | `roundedCross` | 轨迹与轮廓 / Traces & Outlines |
| 横向无穷环 / Infinity Loop · Horizontal | `horizontalInfinity` | 横向 / Horizontal |
| 竖向无穷环 / Infinity Loop · Vertical | `verticalInfinity` | 竖向 / Vertical |
| 横向胶囊环 / Capsule Orbit · Horizontal | `horizontalCapsuleOrbit` | 横向 / Horizontal |
| 竖向胶囊环 / Capsule Orbit · Vertical | `verticalCapsuleOrbit` | 竖向 / Vertical |

The named families reference [torus knots](https://mathworld.wolfram.com/TorusKnot.html), [Viviani's curve](https://mathworld.wolfram.com/VivianisCurve.html), [hippopedes](https://mathworld.wolfram.com/Hippopede.html), and [epitrochoids](https://mathworld.wolfram.com/Epitrochoid.html). Projections, scaling, breathing, and harmonic compositions are chosen for this loading-animation catalog. Capsule tracks use arc-length parameterization of tangent semicircles and straight segments.

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

The initial 21 formulas were independently implemented using [Paidax01/math-curve-loaders](https://github.com/Paidax01/math-curve-loaders) as a reference catalog. The additional 82 curves use mathematical and physics parameterizations. Named curves in the expanded square set were checked against [Wolfram MathWorld](https://mathworld.wolfram.com/), including its [circle involute](https://mathworld.wolfram.com/CircleInvolute.html), [cissoid](https://mathworld.wolfram.com/CissoidofDiocles.html), [tractrix](https://mathworld.wolfram.com/Tractrix.html), and [cycloid](https://mathworld.wolfram.com/Cycloid.html) references. This repository does not copy the reference source.
