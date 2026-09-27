import CurveCore
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct CurveDetailView: View {
    let definition: CurveDefinition
    @Binding var parameters: CurveParameters
    let reset: () -> Void
    @State private var copyConfirmation = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Form {
            Section("Preview") {
                CurveAnimationView(definition: definition, parameters: parameters,
                                   isAnimating: scenePhase == .active && !reduceMotion)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 300)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("\(definition.title) curve preview")
                if reduceMotion {
                    Label("Animation paused for Reduce Motion", systemImage: "pause.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Section("Equation") {
                Text(definition.equation)
                    .font(.body.monospaced())
                    .textSelection(.enabled)
                Text(definition.summary)
                    .foregroundStyle(.secondary)
                Button("Copy Equation", systemImage: "doc.on.doc") {
                    copy(definition.equation, confirmation: "Equation copied")
                }
                Button("Copy Swift Snippet", systemImage: "curlybraces") {
                    copy(swiftSnippet, confirmation: "Swift snippet copied")
                }
                if !copyConfirmation.isEmpty {
                    Text(copyConfirmation)
                        .font(.callout)
                        .accessibilityLabel(copyConfirmation)
                }
            }
            CurveControlsView(definition: definition, parameters: $parameters, reset: reset)
        }
        .formStyle(.grouped)
        .navigationTitle(definition.title)
    }

    var swiftSnippet: String {
        """
        import CurveCore

        // \(definition.title): \(definition.equation)
        // CurveCore evaluates and normalizes the formula, including pulse and rotation.
        if let definition = CurveCatalog.definition(for: .\(definition.id.rawValue)) {
            let parameters = CurveParameters(
                particleCount: \(parameters.particleCount),
                trail: \(parameters.trail),
                loopDuration: \(parameters.loopDuration),
                pulseDuration: \(parameters.pulseDuration),
                rotationDuration: \(parameters.rotationDuration),
                strokeWidth: \(parameters.strokeWidth)
            )
            let elapsedSeconds = 0.0
            let points = CurveSampler.samples(
                for: definition, parameters: parameters,
                phase: elapsedSeconds, count: parameters.particleCount
            )
            let preview = CurveAnimationView(definition: definition, parameters: parameters)
            // Use points for custom drawing, or embed preview in a SwiftUI view.
            _ = (points, preview)
        }
        """
    }

    private func copy(_ text: String, confirmation: String) {
        #if canImport(UIKit)
        UIPasteboard.general.string = text
        copyConfirmation = confirmation
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        copyConfirmation = NSPasteboard.general.setString(text, forType: .string)
            ? confirmation : "Copy failed. Please try again."
        #endif
        AccessibilityNotification.Announcement(copyConfirmation).post()
    }
}
