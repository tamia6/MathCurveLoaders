# Curve Expansion and Bilingual UI Implementation Plan

> **For agentic workers:** Use subagent-driven development. Complete each checked item against this repository, then review the combined diff.

**Goal:** Add nine distinct mathematical curves and English/Chinese UI and curve metadata while keeping `CurveCore` reusable.

**Architecture:** Formula sampling and bilingual curve metadata live in `CurveCore`. SwiftUI app views receive a `CurveLanguage` selected by a persisted control above the gallery; formulas and curve IDs remain language independent.

**Tech Stack:** Swift 5.9, SwiftUI, Swift Package Manager, Xcode for iOS/iPadOS 17+ and macOS 14+.

## Global constraints

- Keep all math in `CurveCore`; no third-party dependencies or reference-source copying.
- Keep the original 21 IDs and their English metadata/API available to callers.
- New IDs: `epicycloid`, `hypocycloid`, `starTrochoid`, `archimedeanSpiral`, `logarithmicSpiral`, `superellipse`, `lissajousKnot`, `harmonograph`, `fourierDrawing` (30 total).
- Existing `butterflyPhase` already supplies the butterfly formula.

## Task 1: CurveCore catalog and sampling

**Files:** `CurveCore/Sources/CurveCore/CurveDefinition.swift`, `CurveCatalog.swift`, `CurveSampler.swift`, `CurveCore/Checks/main.swift`.

**Interface:** Add `CurveLanguage` with `.english`/`.chinese`, plus `CurveDefinition.title(in:)` and `summary(in:)`. Retain `title`, `summary`, `equation`, `CurveCatalog.all`, and `CurveSampler.samples`.

- [x] Add nine `CurveID` and `CurveKind` cases and catalog entries with finite default parameters.
- [x] Implement rolling-circle, spiral, superellipse, Lissajous, harmonograph, and Fourier formulas; scale all to the existing 100×100 canvas coordinates.
- [x] Update `CurveCoreCheck` to require all 30 unique IDs, finite samples, and nondegenerate new shapes.
- [x] Run `cd CurveCore && swift run CurveCoreCheck` and confirm exit 0.

## Task 2: Chinese curve metadata

**File:** `CurveCore/Sources/CurveCore/CurveTranslations.swift`.

**Interface:** `CurveTranslations.values: [CurveID: (title: String, summary: String)]`, consumed by `CurveDefinition.title(in:)` and `summary(in:)`.

- [x] Provide natural Chinese titles and short descriptions for every one of the 30 IDs.
- [x] Check that every `CurveCatalog.all` ID has a nonempty translation.

## Task 3: Bilingual native app

**Files:** `App/ContentView.swift`, `CurveGalleryView.swift`, `CurveDetailView.swift`, `CurveControlsView.swift`, `App/Checks/main.swift`.

- [x] Add an `EN`/`中文` gallery selector persisted with `@AppStorage`.
- [x] Translate navigation, search, empty state, preview/form/controls, copy feedback, accessibility text, labels, and units.
- [x] Search both language titles and summaries plus equations; copied Swift snippets retain stable curve IDs.
- [x] Update the existing app check for 30 curves and bilingual search.

## Task 4: Integrate and review

**Files:** `README.md`, `AGENTS.md` if workflow guidance changes.

- [x] Document the 30 IDs, language switch, and Swift Package reuse.
- [x] Run `swift run CurveCoreCheck`, macOS and generic iOS Simulator Xcode builds, and `./script/build_and_run.sh --verify`.
- [x] Inspect iPhone and iPad screens in both languages, check curve selection and Reduce Motion behavior, review the combined diff, then commit.
