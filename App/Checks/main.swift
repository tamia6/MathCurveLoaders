// Run from the repository root (macOS, Xcode command-line tools):
// mkdir -p .build/task-3-check
// xcrun swiftc -emit-library -emit-module -module-name CurveCore CurveCore/Sources/CurveCore/*.swift -emit-module-path .build/task-3-check/CurveCore.swiftmodule -o .build/task-3-check/libCurveCore.dylib
// xcrun swiftc App/ContentView.swift App/CurveGalleryView.swift App/CurveDetailView.swift App/CurveControlsView.swift App/Checks/main.swift -I .build/task-3-check -L .build/task-3-check -lCurveCore -Xlinker -rpath -Xlinker @executable_path -o .build/task-3-check/check
// .build/task-3-check/check
import CurveCore
import SwiftUI

@MainActor
func checkGallery() {
    assert(CurveGalleryView.definitions(matching: "").count == 21)
    assert(CurveGalleryView.definitions(matching: "ROSE").count == 5)
    assert(CurveGalleryView.definitions(matching: "  rose  ").count == 5)
    assert(CurveGalleryView.definitions(matching: "1.57").map(\.id) == [.lissajousDrift])
    assert(CurveGalleryView.definitions(matching: "no such curve").isEmpty)

    for definition in CurveCatalog.all {
        var parameters = definition.defaultParameters
        let binding = Binding(get: { parameters }, set: { parameters = $0 })
        let reset = { parameters = definition.defaultParameters }
        let controls = CurveControlsView(definition: definition, parameters: binding, reset: reset)
        controls.particleCount.wrappedValue = 100
        assert(parameters.particleCount == 100)
        let changes: [(KeyPath<CurveParameters, Double>, Double)] = [
            (\.trail, 0.5), (\.loopDuration, 8), (\.pulseDuration, 7),
            (\.rotationDuration, 40), (\.strokeWidth, 7)
        ]
        for (keyPath, value) in changes {
            let before = parameters
            controls.binding(for: keyPath).wrappedValue = value
            assert(parameters[keyPath: keyPath] == value)
            assert(parameters.particleCount == before.particleCount)
            for (other, _) in changes where other != keyPath {
                assert(parameters[keyPath: other] == before[keyPath: other])
            }
        }
        let detail = CurveDetailView(definition: definition, parameters: binding, reset: reset)
        let snippet = detail.swiftSnippet
        assert(snippet.contains(".\(definition.id.rawValue)"))
        assert(snippet.contains("particleCount: 100"))
        assert(snippet.contains("trail: 0.5"))
        assert(snippet.contains("loopDuration: 8.0"))
        assert(snippet.contains("pulseDuration: 7.0"))
        assert(snippet.contains("rotationDuration: 40.0"))
        assert(snippet.contains("strokeWidth: 7.0"))
        assert(snippet.contains("CurveSampler.samples("))
        assert(snippet.contains("normalized base points with pulse, without renderer-only rotation"))
        assert(snippet.contains("full animated preview, including rotation only when definition.rotates is true"))
        assert(snippet.contains(definition.equation))
        if let directory = CommandLine.arguments.dropFirst().first {
            try! snippet.write(toFile: "\(directory)/\(definition.id.rawValue).swift", atomically: true, encoding: .utf8)
        }
        controls.binding(for: \.trail).wrappedValue = .infinity
        assert(parameters.trail == 0.68)
        controls.binding(for: \.pulseDuration).wrappedValue = .nan
        assert(parameters.pulseDuration == 1.8)
        controls.particleCount.wrappedValue = -1
        assert(parameters.particleCount == 24)
        controls.reset()
        assert(parameters == definition.defaultParameters)
        assert(detail.parameters == definition.defaultParameters)
    }
    print("Task 3 checks passed: search, six live bindings, clamping, reset, and 21 Swift snippets.")
}

MainActor.assumeIsolated { checkGallery() }
