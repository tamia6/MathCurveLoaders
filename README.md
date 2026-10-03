# Math Curve Loaders

**基于数学的 Loading 图案，为应用中的等待加入动画。**

**Math-based loading animations for your apps and websites.**

[在线演示 / Live demo](https://tamia6.github.io/MathCurveLoaders/) · [图案示例 / Sample pattern](https://tamia6.github.io/MathCurveLoaders/#torusKnotProjection) · [MIT License](LICENSE)

将数学曲线转化为可复用的加载动画。目前包含 **103 种图案**，支持中英双语、实时调参，提供原生 SwiftUI 应用、独立 `CurveCore` Swift Package，以及 HTML5 Canvas 画廊。

Turn mathematical curves into reusable loading animations. Explore **103 patterns** with English and Chinese descriptions, live controls, a native SwiftUI app, the standalone `CurveCore` Swift package, and an HTML5 Canvas gallery.

## 使用方式 / Ways to use

| 入口 / Entry | 用途 / Purpose | 代码复用 / Reuse |
| --- | --- | --- |
| [H5 画廊 / Web gallery](https://tamia6.github.io/MathCurveLoaders/) | 浏览动画，点击卡片弹窗放大并调参 / Browse animated cards; open a modal to preview and tune | 复制独立 H5 代码 / Copy self-contained H5 code |
| SwiftUI 应用 / Native app | 在 iOS、iPadOS、macOS 上挑选和调试 / Choose and tune on Apple platforms | 复制 Swift 代码 / Copy a Swift snippet |
| `CurveCore` | 嵌入原生动画，或采样曲线自行绘制 / Embed native animations or sample curves for custom drawing | 本地 Swift Package / Local Swift package |

- 支持方形、横向、竖向布局及分类搜索。 / Square, horizontal, and vertical layouts with grouped search.
- 可调整粒子数量、拖尾长度、运动周期、呼吸周期、旋转周期和线条粗细；不旋转的图案禁用旋转控制。 / Six controls: particles, trail, loop duration, pulse duration, rotation duration, and stroke width; rotation is disabled for non-rotating patterns.
- 无第三方运行时依赖，遵循系统“减少动态效果”设置。 / No third-party runtime dependencies; respects reduced-motion preferences.

## H5 画廊 / Web gallery

### 浏览与调参 / Browse and tune

1. 打开[在线演示](https://tamia6.github.io/MathCurveLoaders/)，搜索名称、说明或公式，或筛选方形、横向和竖向图案。
2. 点击图案卡片，在弹窗中查看大预览、公式与说明，并实时调整参数。
3. 使用暂停、重置或 **复制 H5 代码**；关闭按钮、Esc 和点击遮罩均可关闭弹窗，返回原来的画廊位置。

Browse the [live demo](https://tamia6.github.io/MathCurveLoaders/), search by name, description, or equation, and filter by layout. Click a card for a large preview, equation, live controls, pause, reset, and **Copy H5 code**. Close the modal with its close button, Escape, or the backdrop; the gallery keeps its scroll position.

图案链接使用 `#curveID`，打开后直接显示对应弹窗，例如[横向胶囊环](https://tamia6.github.io/MathCurveLoaders/#horizontalCapsuleOrbit)。 / Links with `#curveID` open the matching modal, for example [Capsule Orbit · Horizontal](https://tamia6.github.io/MathCurveLoaders/#horizontalCapsuleOrbit).

### 复制到网页 / Embed in HTML

点击 **复制 H5 代码**，将复制内容粘贴到 HTML 页面的 `<body>` 中即可运行。

Click **Copy H5 code** and paste the result into an HTML page's `<body>`.

- 代码包含 canvas、内联样式、绘制脚本、所选图案数据及当前参数，无需额外文件或网络请求。 / Includes the canvas, inline styles, renderer, selected samples, and current parameters; no extra files or network requests.
- 可重复粘贴多个独立动画；修改 canvas 的内联宽高即可调整尺寸。 / Repeat the snippet for independent loaders; edit the canvas inline width and height to resize.
- 图案数据内嵌在代码中，因此复制内容较长。 / Embedded samples make the copied snippet relatively large.
- React、Vue 等框架项目需通过生命周期挂载 canvas 并执行脚本；通过 `innerHTML` 插入的脚本不会自动执行。 / In framework projects, mount the canvas and run the script through the framework lifecycle; scripts inserted through `innerHTML` do not execute automatically.
- 剪贴板不可用时，页面会显示代码供手动复制。 / If clipboard access fails, the page displays the code for manual copying.

### 本地运行 / Run locally

```sh
git clone https://github.com/tamia6/MathCurveLoaders.git
cd MathCurveLoaders
python3 -m http.server 8765 --directory web
```

打开 / Open [http://localhost:8765](http://localhost:8765)。无需 npm 安装或 JavaScript 构建。 / No npm install or JavaScript build step.

网页按可见预览加载采样数据，后台标签页停止绘制；弹窗打开时暂停画廊缩略图绘制，集中显示大预览。 / Samples load as previews become visible. Rendering stops in hidden tabs; the modal suspends gallery thumbnail rendering while showing the enlarged preview.

## 图案分类 / Pattern catalog

| 布局与分类 / Layout and group | 数量 / Count | 示例 ID / Example IDs |
| --- | ---: | --- |
| 方形 · 花瓣与轨道 / Square · Flowers & Orbits | 21 | `roseCurve`, `breathingCircle`, `beanOrbit` |
| 方形 · 滚线与尖点 / Square · Rolling Curves & Cusps | 13 | `epicycloid`, `hypotrochoidLoop`, `epitrochoidBloom` |
| 方形 · 螺旋与生长 / Square · Spirals & Growth | 12 | `archimedeanSpiral`, `fermatSpiral`, `circleInvolute` |
| 方形 · 轨迹与轮廓 / Square · Traces & Outlines | 31 | `torusKnotProjection`, `vivianiWindow`, `harmonicRibbon` |
| 方形 · 物理与运动 / Square · Physics & Motion | 10 | `doublePendulum`, `lorenzAttractor`, `drivenOscillator` |
| 横向 / Horizontal | 8 | `horizontalInfinity`, `horizontalCapsuleOrbit`, `horizontalWavePacket` |
| 竖向 / Vertical | 8 | `verticalInfinity`, `verticalCapsuleOrbit`, `verticalSpring` |
| **总计 / Total** | **103** | **87 方形 / square + 8 横向 / horizontal + 8 竖向 / vertical** |

完整 ID、公式、双语说明、比例和默认参数见 [Swift 目录](CurveCore/Sources/CurveCore/CurveCatalog.swift)及[网页元数据](web/data/catalog.json)。ID 和公式不随语言切换。 / See the [Swift catalog](CurveCore/Sources/CurveCore/CurveCatalog.swift) and [web metadata](web/data/catalog.json) for all IDs, equations, bilingual descriptions, ratios, and defaults. IDs and equations are language independent.

最近增加的闭合路径包括呼吸圆环、环面结投影、维维亚尼窗、马蹄椭圆、外旋轮花、谐波丝带、圆润十字、豆形轨道，以及横竖无穷环与胶囊环。 / Recent closed paths include the breathing ring, torus knot projection, Viviani window, hippopede oval, epitrochoid bloom, harmonic ribbon, rounded cross, bean orbit, and horizontal/vertical infinity and capsule tracks.

## 原生应用 / Native app

**要求 / Requirements:** iOS / iPadOS 17.0+、macOS 14.0+，以及支持这些目标的 Xcode。 / Xcode with support for these deployment targets.

```sh
open MathCurveLoaders.xcodeproj
```

选择 `MathCurveLoaders` scheme 和 macOS 或 iOS/iPadOS 目标运行。原生应用使用分类侧栏和详情视图，详情中提供预览、公式、参数控制及 Swift 代码复制。

Choose the `MathCurveLoaders` scheme and a macOS or iOS/iPadOS destination. The app uses a grouped sidebar and detail view with preview, equation, controls, and Swift snippet copying.

macOS 终端构建并启动 / Build and launch on macOS:

```sh
./script/build_and_run.sh
```

脚本还支持 `--debug`、`--logs`、`--telemetry`、`--verify`；每次运行会重新构建并重启应用。`--verify` 检查进程是否已启动。 / Additional modes rebuild and restart the app for debugging, logging, telemetry, or process-launch verification.

## 原生代码复用 / Reuse CurveCore

`CurveCore` 位于仓库子目录，仓库根目录没有 `Package.swift`。当前请克隆仓库后，将 **`CurveCore/` 添加为本地 Swift Package**；不能直接把仓库 URL 作为根级 SwiftPM 依赖，也没有 `1.0.0` 发布标签。

`CurveCore` lives in a subdirectory; the repository root has no `Package.swift`. Clone the repository and add **`CurveCore/` as a local Swift package**. The repository URL is not a root-level SwiftPM dependency, and no `1.0.0` release tag is provided.

另一 Swift Package 中可使用 / In another Swift package:

```swift
.package(path: "../MathCurveLoaders/CurveCore")
```

目标依赖添加 `.product(name: "CurveCore", package: "CurveCore")`；Xcode 项目使用添加本地包的入口，选择 `CurveCore/` 并链接 `CurveCore` 产品。 / Add the product to your target dependencies; in Xcode, add the local `CurveCore/` package and link its `CurveCore` product.

```swift
import CurveCore
import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        if let curve = CurveCatalog.definition(for: .horizontalCapsuleOrbit) {
            CurveAnimationView(
                definition: curve,
                parameters: curve.defaultParameters
            )
            .aspectRatio(curve.aspectRatio, contentMode: .fit)
            .frame(width: 240)
        }
    }
}
```

公开 API / Public APIs:

| API | 用途 / Purpose |
| --- | --- |
| `CurveCatalog.all`, `definition(for:)` | 获取图案定义 / Look up definitions |
| `CurveParameters` | 设置六项动画参数并限制到有效范围 / Set six parameters with bounded values |
| `CurveAnimationView` | 嵌入 SwiftUI 动画；`isAnimating` 控制播放 / Embed an animation with playback control |
| `CurveSampler.samples(for:parameters:phase:count:)` | 按秒采样归一化坐标，供自定义绘制；不含渲染层旋转 / Sample normalized points at elapsed seconds; renderer rotation is excluded |
| `title(in:)`, `summary(in:)` | 获取中文或英文元数据 / Read localized metadata |

## Agent 开发指引 / Agent development guide

先读 [AGENTS.md](AGENTS.md)。公式只有一个来源：`CurveCore`；原生界面和 H5 消费其定义与采样结果。 / Read [AGENTS.md](AGENTS.md) first. `CurveCore` is the source of truth for formulas; native and web renderers consume its definitions and samples.

| 文件 / Path | 职责 / Responsibility |
| --- | --- |
| `CurveCore/Sources/CurveCore/CurveDefinition.swift` | ID、类型、公开参数和定义 / IDs, kinds, public parameters and definitions |
| `CurveCore/Sources/CurveCore/CurveCatalog.swift` | 英文元数据、公式说明及默认参数 / English metadata, equations and defaults |
| `CurveCore/Sources/CurveCore/CurveSampler.swift` | 数学公式及数值积分轨迹 / Formulas and integrated tracks |
| `CurveCore/Sources/CurveCore/CurveTranslations.swift` | 中文名称与说明 / Chinese metadata |
| `App/CurveGalleryView.swift` | 原生搜索和分类，同时供网页导出器读取分类 / Native search and groups; group source for web export |
| `web/app.js`, `index.html`, `style.css` | 网页画廊、弹窗和实时控制 / Web gallery, modal and live controls |
| `web/renderer.mjs` | Canvas 插值和绘制 / Canvas interpolation and rendering |
| `web/snippet.mjs` | 独立 H5 代码导出，复用同一绘制器 / Self-contained H5 export using the shared renderer |
| `CurveCore/Sources/CurveWebExport/main.swift`, `script/export_web.py` | 生成采样数据和元数据 / Generate samples and metadata |
| `web/data/` | 已提交的生成文件；不要手改 / Committed generated assets; do not edit manually |

### 新增或修改图案 / Add or change patterns

1. 在 `CurveID` 和 `CurveKind` 中注册，更新 catalog、sampler 和中文翻译。 / Register both enums; update the catalog, sampler, and translations.
2. 在 `SquareCurveCategory.category(for:)` 中分组；横竖图案返回 `nil`，用 `aspectRatio` 区分（方形 `1`、横向 `3`、竖向 `1/3`）。 / Assign a square group; directional patterns return `nil` and use their aspect ratio.
3. 公式、元数据、默认参数或分类改变后，重新生成网页文件，并更新 README、网页介绍和现有数量断言。 / Regenerate web assets after formula, metadata, default, or group changes; update descriptions and existing count assertions.

从仓库根目录生成网页文件（需要 Swift 工具链） / Regenerate from the repository root with the Swift toolchain:

```sh
python3 script/export_web.py
```

不要在 JavaScript 中复制公式；导出的数据包含 48 个形变相位，每个相位 480 个路径点，双摆和洛伦兹轨迹使用 3,200 个点。浏览器在相位和路径点之间插值，因此 H5 是原生采样的近似，绘制效果不保证逐像素一致。

Do not duplicate formulas in JavaScript. Exported data contains 48 shape phases with 480 path points per phase, or 3,200 for double-pendulum and Lorenz tracks. Browser interpolation approximates the native sampler; rendering is not guaranteed to match pixel for pixel.

### 可用检查命令 / Available checks

按需要从仓库根目录运行。 / Run from the repository root as needed.

```sh
(cd CurveCore && swift run CurveCoreCheck)
node web/check.mjs
xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
./script/build_and_run.sh --verify
```

## GitHub Pages

[在线演示 / Live demo](https://tamia6.github.io/MathCurveLoaders/) 由 [.github/workflows/pages.yml](.github/workflows/pages.yml) 发布。向 `main` 或 `master` 推送 `web/**` 或部署工作流的改动后自动部署，也可手动运行。README 单独改动不会触发网页部署。

The workflow deploys `web/` when web assets or the workflow change on `main` or `master`; it also supports manual dispatch. README-only changes do not trigger deployment.

Fork 后在 **Settings → Pages → Source → GitHub Actions** 启用部署，并更新 `web/site.json` 中的仓库链接及 README 演示地址。 / For forks, enable GitHub Actions as the Pages source and update the repository link in `web/site.json` and the README demo URL.

## 来源与许可 / References and license

前 21 种图案参考 [Paidax01/math-curve-loaders](https://github.com/Paidax01/math-curve-loaders) 独立实现；H5 采用该项目的画廊与放大预览交互思路。其余 82 种使用数学和物理参数化。 / The initial 21 patterns were independently implemented using the original catalog as a reference; the H5 gallery and enlarged-preview interaction also take inspiration from it. The other 82 use mathematical and physics parameterizations.

经典曲线参考 [Wolfram MathWorld](https://mathworld.wolfram.com/)，包括 [Viviani's curve](https://mathworld.wolfram.com/VivianisCurve.html)、[hippopede](https://mathworld.wolfram.com/Hippopede.html)、[epitrochoid](https://mathworld.wolfram.com/Epitrochoid.html) 和 [torus knot](https://mathworld.wolfram.com/TorusKnot.html)。投影、呼吸变化和谐波组合按 Loading 展示需要选取；双摆和洛伦兹轨迹采用数值积分，洛伦兹图案展示状态空间轨迹。 / Named curves reference MathWorld; projections, breathing, and harmonic compositions are chosen for loading animations. Double-pendulum and Lorenz paths are numerically integrated; the Lorenz pattern is a state-space trajectory.

本仓库采用 [MIT License](LICENSE)。 / This repository is licensed under MIT.
