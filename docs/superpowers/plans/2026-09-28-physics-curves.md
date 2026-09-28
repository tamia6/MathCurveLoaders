# Physics Curves Implementation Plan

> **For agentic workers:** Use subagent-driven development for the independent catalog and sampling changes, then review the combined diff.

**Goal:** Add magnetic helix, double pendulum, and Lorenz attractor to the 30-curve bilingual SwiftUI gallery.

**Architecture:** Keep the catalog, translations, and all formulas in `CurveCore`. The helix is sampled analytically. Double pendulum and Lorenz paths use deterministic RK4 tracks prepared off the UI thread, interpolated by the existing public sampler and drawn by the existing SwiftUI Canvas.

**Tech Stack:** Swift 5.9, SwiftUI, Swift Package Manager; iOS/iPadOS 17+ and macOS 14+.

## Constraints

- Preserve the public `CurveCatalog`, `CurveSampler`, and `CurveAnimationView` interfaces.
- Keep English and Chinese metadata for all 33 curve IDs; do not add dependencies.
- Preserve the existing Reduce Motion rendering path.

## Task 1: Catalog and bilingual metadata

**Files:** `CurveCore/Sources/CurveCore/CurveDefinition.swift`, `CurveCatalog.swift`, `CurveTranslations.swift`, `README.md`.

- [x] Add three stable IDs and kinds, accurate equations, defaults, English and Chinese titles and summaries.
- [x] Update README to 33 curves and list the new IDs.

## Task 2: Sampling

**File:** `CurveCore/Sources/CurveCore/CurveSampler.swift`.

- [x] Project a two-turn magnetic helix onto the current 2D canvas.
- [x] Prepare a double pendulum bob path and Lorenz state-space projection with RK4; interpolate for arbitrary progress.
- [x] Keep every new point finite and within the normalized canvas at default parameters.

## Task 3: Integration

- [x] Compile the Swift package and native app for macOS and iOS Simulator.
- [x] Inspect all three curves in the running app, review the diff, and commit the result.
