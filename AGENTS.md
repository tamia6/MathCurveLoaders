# Agent instructions

## Canonical commands

Run from the repository root:

```sh
(cd CurveCore && swift run CurveCoreCheck)
xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project MathCurveLoaders.xcodeproj -scheme MathCurveLoaders -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
./script/build_and_run.sh --verify
```

## Project boundaries

- `CurveCore` is the public, dependency-free Swift Package boundary. Keep public curve definitions, parameter values, sampling, and `CurveAnimationView` there.
- Keep all curve formulas in `CurveCore`; app code must consume public package APIs.
- Keep Chinese curve titles and descriptions in `CurveCore/Sources/CurveCore/CurveTranslations.swift`; access them through `CurveDefinition.title(in:)` and `summary(in:)`. Curve IDs and equations are language independent.
- SwiftUI app ownership is in `App/`: `MathCurveLoadersApp.swift` starts the app, `ContentView.swift` owns navigation and selection, `CurveGalleryView.swift` owns the gallery, `CurveDetailView.swift` owns preview and copy UI, and `CurveControlsView.swift` owns parameter controls.
- `MathCurveLoaders.xcodeproj` owns the universal iOS/iPadOS and macOS app target and the local `CurveCore` dependency.

## Constraints

- Minimum targets are iOS/iPadOS 17.0 and macOS 14.0.
- Do not add third-party dependencies.
- Reimplement formulas independently; do not copy reference source.
- Use SwiftUI `Canvas` and `TimelineView` for animation, and preserve Reduce Motion behavior.
