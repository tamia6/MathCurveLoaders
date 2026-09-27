# Math Curve Loaders Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reusable MIT-licensed Swift Package and a native SwiftUI gallery of the reference repository's 21 curve animations for iOS/iPadOS 17 and macOS 14+.

**Architecture:** `CurveCore` owns curve definitions, bounded parameters, deterministic point sampling, and a reusable animated SwiftUI renderer. The Xcode app target depends on this local package and supplies only the gallery, navigation, controls, and copy actions, adapting navigation to available width.

**Tech Stack:** Swift 5.9 language mode, Swift Package Manager, SwiftUI `Canvas` and `TimelineView`, Xcode project; no external dependencies.

## Global Constraints

- Minimum platforms: iOS/iPadOS 17.0 and macOS 14.0.
- Keep `CurveCore` usable as a local or Git URL Swift package by other projects.
- License original project code under MIT; do not copy source from the reference repository.
- Reimplement the reference formulas independently and link to the reference in README.
- Use SwiftUI controls for interactive/accessibility elements; animate drawing with `Canvas` and `TimelineView`.
- Reduce Motion must stop continuous animation.
- No persistence, user-authored formulas, networking, or third-party packages.

---

## File Map

- `CurveCore/Package.swift`: `CurveCore` library and assertion-check executable targets.
- `CurveCore/Sources/CurveCore/CurveDefinition.swift`: public `CurveID`, `CurveParameters`, `CurveDefinition`, and `CurvePoint` values.
- `CurveCore/Sources/CurveCore/CurveCatalog.swift`: metadata and defaults for all 21 animations.
- `CurveCore/Sources/CurveCore/CurveSampler.swift`: deterministic mathematical sampling and parameter clamping.
- `CurveCore/Sources/CurveCore/CurveAnimationView.swift`: reusable public SwiftUI `Canvas` renderer with timeline and Reduce Motion behavior.
- `CurveCore/Checks/main.swift`: dependency-free assertions for catalog coverage, finite samples, and bounds.
- `MathCurveLoaders.xcodeproj/project.pbxproj`: universal iOS/iPadOS + macOS app targets and local `CurveCore` package reference.
- `App/MathCurveLoadersApp.swift`: app entry point.
- `App/ContentView.swift`: adaptive navigation and selected-curve state.
- `App/CurveGalleryView.swift`: searchable curve list/grid.
- `App/CurveDetailView.swift`: preview, formula, explanation, and copy actions.
- `App/CurveControlsView.swift`: controls for the selected definition's supported parameters and reset.
- `script/build_and_run.sh`: one Xcode build/launch entry point with run/debug/logs/telemetry/verify modes.
- `.codex/environments/environment.toml`: Codex Run action.
- `README.md`: user setup, package reuse, feature map, and verification commands.
- `AGENTS.md`: concise agent rules, file ownership, and canonical build/check commands.
- `LICENSE`: MIT license for this new project.
- `.gitignore`: Xcode and SwiftPM build output exclusions.

## Task 1: Implement reusable curve math package

**Files:**
- Create: `CurveCore/Package.swift`
- Create: `CurveCore/Sources/CurveCore/CurveDefinition.swift`
- Create: `CurveCore/Sources/CurveCore/CurveCatalog.swift`
- Create: `CurveCore/Sources/CurveCore/CurveSampler.swift`
- Create: `CurveCore/Checks/main.swift`

**Interfaces:**
- `CurveID: String, CaseIterable, Identifiable, Sendable` has exactly these cases: `originalThinking`, `thinkingFive`, `thinkingNine`, `roseOrbit`, `roseCurve`, `roseTwo`, `roseThree`, `roseFour`, `lissajousDrift`, `lemniscateBloom`, `hypotrochoidLoop`, `threePetalSpiral`, `fourPetalSpiral`, `fivePetalSpiral`, `sixPetalSpiral`, `butterflyPhase`, `cardioidGlow`, `cardioidHeart`, `heartWave`, `spiralSearch`, `fourierFlow`.
- `CurveParameters: Equatable, Sendable` exposes particle count, trail, loop duration, pulse duration, rotation duration, and stroke width; its initializer clamps values to documented finite ranges.
- `CurveDefinition: Identifiable, Sendable` exposes `id`, `title`, `equation`, `summary`, `defaultParameters`, and the internal formula kind.
- `CurveCatalog.all: [CurveDefinition]` contains every `CurveID` exactly once; `CurveCatalog.definition(for:)` returns the corresponding definition.
- `CurvePoint: Equatable, Sendable` stores normalized `x` and `y` doubles.
- `CurveSampler.samples(for:parameters:phase:count:) -> [CurvePoint]` is deterministic for identical inputs and returns finite coordinates; normalizing to view bounds is a renderer concern.
- Before implementing formulas, inspect the reference `main.js`/`original.js` and read equation comments only. Recreate formula logic in Swift; do not copy implementation text.

- [ ] **Step 1: Create package manifest and public value types.** Define a `CurveCore` library product and a `CurveCoreCheck` executable target at `Checks`; set `.iOS(.v17)` and `.macOS(.v14)` and Swift tools 5.9.
- [ ] **Step 2: Add the smallest failing assertions in `Checks/main.swift`.** Assert 21 unique IDs, a definition for each ID, parameter clamping, and finite points from each definition.
- [ ] **Step 3: Run `cd CurveCore && swift run CurveCoreCheck` and confirm it fails because catalog/sampler symbols are not implemented.**
- [ ] **Step 4: Read reference formula descriptions and implement the catalog and sampler.** Keep each curve's geometry in a `CurveKind` switch, sharing only small coordinate helpers; don't introduce a plug-in registry.
- [ ] **Step 5: Run `cd CurveCore && swift run CurveCoreCheck` and `cd CurveCore && swift build`.** Both must exit 0.
- [ ] **Step 6: Commit the package as `feat: add reusable curve core package`.**

## Task 2: Add reusable animated SwiftUI renderer

**Files:**
- Create: `CurveCore/Sources/CurveCore/CurveAnimationView.swift`
- Modify: `CurveCore/Checks/main.swift`

**Interfaces:**
- `public struct CurveAnimationView: View` accepts `definition: CurveDefinition`, `parameters: CurveParameters`, and `isAnimating: Bool = true`.
- The renderer consumes only the public definition and parameters; clients do not need the gallery app.

- [ ] **Step 1: Extend the assertion check with a static rendering input check by constructing a default definition and parameters; keep sample generation available when animation is disabled.**
- [ ] **Step 2: Implement the renderer with `TimelineView(.animation)` and `Canvas`; map normalized points into the available size, draw the curve and trail, and avoid storing time-derived state.**
- [ ] **Step 3: Read `@Environment(\.accessibilityReduceMotion)` and freeze phase when Reduce Motion is enabled or `isAnimating` is false.**
- [ ] **Step 4: Run `cd CurveCore && swift run CurveCoreCheck && swift build`.** Expected: both commands exit 0.
- [ ] **Step 5: Commit as `feat: add reusable curve animation view`.**

## Task 3: Build adaptive native gallery app

**Files:**
- Create: `MathCurveLoaders.xcodeproj/project.pbxproj`
- Create: `App/MathCurveLoadersApp.swift`
- Create: `App/ContentView.swift`
- Create: `App/CurveGalleryView.swift`
- Create: `App/CurveDetailView.swift`
- Create: `App/CurveControlsView.swift`
- Modify: `CurveCore/Package.swift` only if an app-facing package API issue is found.

**Interfaces:**
- `ContentView` owns selected `CurveID` and `CurveParameters`, and resolves the selected `CurveDefinition` from `CurveCatalog`.
- `CurveGalleryView` receives `selection: Binding<CurveID?>` and lists `CurveCatalog.all`.
- `CurveDetailView` receives a `CurveDefinition`, `parameters: Binding<CurveParameters>`, and a reset action.
- `CurveControlsView` receives `definition: CurveDefinition`, `parameters: Binding<CurveParameters>`, and a reset action. It only shows controls that apply to the definition.

- [ ] **Step 1: Create a minimal Xcode project with iOS and macOS app destinations, deployment targets 17.0/14.0, shared app source, and a local package reference to `CurveCore`.**
- [ ] **Step 2: Add app entry point and a `NavigationSplitView` gallery/detail shell.** On compact iPhone widths selection navigates to detail; on iPad and macOS sidebar and detail remain visible.
- [ ] **Step 3: Add all catalog rows with title, short equation, and animated thumbnail using `CurveAnimationView`.** Use native `.searchable` filtering.
- [ ] **Step 4: Add detail preview, equation and explanatory text, parameter controls with accessible labels, and reset-to-definition-defaults.**
- [ ] **Step 5: Add copy buttons for equation and Swift formula snippet using `UIPasteboard`/`NSPasteboard` behind platform conditionals; provide a confirmation label accessible to VoiceOver.**
- [ ] **Step 6: Build macOS and iOS simulator targets with `xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build` and `xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`.** Both must succeed.
- [ ] **Step 7: Commit as `feat: add multiplatform curve gallery app`.**

## Task 4: Add MIT license, agent-focused docs, and run integration

**Files:**
- Create: `LICENSE`
- Create: `README.md`
- Create: `AGENTS.md`
- Create: `.gitignore`
- Create: `script/build_and_run.sh`
- Create: `.codex/environments/environment.toml`

- [ ] **Step 1: Add standard MIT license text for 2026, with copyright holder `Tamia`.**
- [ ] **Step 2: Document platforms, Xcode open/run steps, exact package check and simulator/macOS build commands, 21 curve IDs, and the public package reuse pattern:**

```swift
.package(path: "../MathCurveLoaders/CurveCore")
```

  Explain that remote reuse requires pushing this repository and replacing the local path with its Git URL and a version/revision requirement.
- [ ] **Step 3: Write `AGENTS.md` with canonical commands, the public package boundary, SwiftUI app file ownership, minimum OS versions, no-dependency and no-copy constraints, and the rule to keep curve formulas in `CurveCore`.**
- [ ] **Step 4: Add `.gitignore` for `.build/`, Xcode `DerivedData/`, `*.xcuserstate`, and user-specific `xcuserdata/`.**
- [ ] **Step 5: Add `script/build_and_run.sh`, executable, defaulting to build and launch the macOS app; support `--debug`, `--logs`, `--telemetry`, and `--verify` with Xcode project build and `/usr/bin/open -n` for the built `.app`.**
- [ ] **Step 6: Add `.codex/environments/environment.toml` with one `Run` action calling `./script/build_and_run.sh`.**
- [ ] **Step 7: Run `cd CurveCore && swift run CurveCoreCheck`, both Task 3 `xcodebuild` commands, and `./script/build_and_run.sh --verify`; confirm all succeed.**
- [ ] **Step 8: Review README links and commands, then commit as `docs: document reuse and agent workflow`.**

## Self-review

- Spec coverage: 21 curves, adjustable animation parameters, formula and explanation, reset/copy, adaptive Apple-platform UI, reusable Swift Package, MIT, README/AGENTS agent guidance, Reduce Motion, and build/check workflow map to Tasks 1–4.
- Scope: HTML/JavaScript webpage and source download are explicitly out of scope in the approved design.
- Placeholder scan: no TODO/TBD steps; every target and command is named.
- Interface consistency: the sampler's normalized `CurvePoint` output feeds the public `CurveAnimationView`; `CurveCatalog` feeds both gallery and detail screens.
