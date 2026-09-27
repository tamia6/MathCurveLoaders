# MathCurveLoaders Design

## Goal

Build a native SwiftUI gallery of the 21 mathematical curve animations in the reference project, for iOS/iPadOS 17 and macOS 14 or later. Keep curve computation and reusable animation UI importable by other Swift projects. License original project code under MIT.

Reference: https://github.com/Paidax01/math-curve-loaders

The reference repository does not show a license in its root file list. Treat it as inspiration and a formula catalog; independently implement the Swift code and do not copy its source. Preserve attribution to the reference in the app README.

## Structure

- `CurveCore/`: standalone Swift Package with public curve definitions, parameter values, point sampling, and reusable SwiftUI animation view. Supports iOS 17 and macOS 14; no third-party dependencies.
- `MathCurveLoaders/`: native SwiftUI app using `CurveCore`, with one cross-platform app target and platform-adaptive layout.
- `MathCurveLoaders.xcodeproj`: launches the app on iOS/iPadOS and macOS, with the package linked as a local dependency.
- `README.md`, `LICENSE`, and `AGENTS.md`: project usage, MIT terms, and concise instructions for coding agents.

## App behavior

Show all reference animations in a searchable/selectable gallery. Selecting one opens a live preview, its equation and short explanation, plus controls for applicable parameters such as particle count, trail, loop, pulse, rotation, and stroke width. Reset restores that curve's defaults. Provide copy actions for the formula and Swift implementation snippet.

Use a compact adaptive grid and detail navigation on iPhone; a gallery/detail split on iPad and macOS. Use SwiftUI controls for interaction and accessibility, and `Canvas` with timeline-driven updates for curve rendering. Respect Reduce Motion by pausing or reducing animation.

## Reuse boundary

`CurveCore` is the public product boundary. Other apps can add it by local path during development or by Git URL after hosting the repository. They may import the curve math only, or use its SwiftUI animation component. The gallery and app navigation remain in the app target.

## Out of scope

Do not reproduce the reference's HTML/JavaScript download or webpage. Do not add persistence, user-authored curves, accounts, networking, or third-party packages.

## Validation

- Build the package and app for macOS, iOS Simulator, and iPad-compatible iOS Simulator destinations.
- Keep one small runnable assertion-based check for curve sampling and parameter bounds.
- Confirm all 21 catalog entries resolve to a definition, reset returns defaults, and reduced-motion behavior stops continuous animation.
- README gives exact build/check commands, deployment targets, package reuse example, source map, and agent constraints.
