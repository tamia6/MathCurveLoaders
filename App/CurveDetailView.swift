import CurveCore
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct CurveDetailView: View {
    let definition: CurveDefinition
    let language: CurveLanguage
    @Binding var parameters: CurveParameters
    let reset: () -> Void
    @State private var copyConfirmation: (english: String, chinese: String)?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Form {
            Section(appText(language, "Preview", "预览")) {
                CurveAnimationView(definition: definition, parameters: parameters,
                                   isAnimating: scenePhase == .active && !reduceMotion)
                    .aspectRatio(definition.aspectRatio, contentMode: .fit)
                    .frame(maxWidth: definition.aspectRatio > 1 ? 600 : definition.aspectRatio < 1 ? 120 : 300)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel(appText(language,
                                                "\(definition.title(in: .english)) curve preview",
                                                "\(definition.title(in: .chinese))预览"))
                if reduceMotion {
                    Label(appText(language, "Animation paused for Reduce Motion", "已开启“减弱动态效果”，动画已暂停"), systemImage: "pause.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Section(appText(language, "Equation", "方程")) {
                Text(definition.equation)
                    .font(.body.monospaced())
                    .textSelection(.enabled)
                Text(definition.summary(in: language))
                    .foregroundStyle(.secondary)
                Button(appText(language, "Copy Equation", "复制方程"), systemImage: "doc.on.doc") {
                    copy(definition.equation, confirmation: ("Equation copied", "方程已复制"))
                }
                Button(appText(language, "Copy Swift Snippet", "复制 Swift 代码"), systemImage: "curlybraces") {
                    copy(swiftSnippet, confirmation: ("Swift snippet copied", "Swift 代码已复制"))
                }
                if let copyConfirmation {
                    Text(appText(language, copyConfirmation.english, copyConfirmation.chinese))
                        .font(.callout)
                }
            }
            CurveControlsView(definition: definition, language: language, parameters: $parameters, reset: reset)
        }
        .formStyle(.grouped)
        .navigationTitle(definition.title(in: language))
    }

    var swiftSnippet: String {
        """
        import CurveCore
        import SwiftUI

        // \(definition.title): \(definition.equation)
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
            // Sample normalized animated points, without renderer-only rotation.
            let points = CurveSampler.samples(
                for: definition, parameters: parameters,
                phase: elapsedSeconds, count: parameters.particleCount
            )
            // Embed the full animated preview, including rotation only when definition.rotates is true.
            let preview = CurveAnimationView(definition: definition, parameters: parameters)
                .aspectRatio(definition.aspectRatio, contentMode: .fit)
            // Use points for custom drawing, or embed preview in a SwiftUI view.
            _ = (points, preview)
        }
        """
    }

    private func copy(_ text: String, confirmation: (english: String, chinese: String)) {
        #if canImport(UIKit)
        UIPasteboard.general.string = text
        copyConfirmation = confirmation
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        copyConfirmation = NSPasteboard.general.setString(text, forType: .string)
            ? confirmation : ("Copy failed. Please try again.", "复制失败，请重试。")
        #endif
        if let copyConfirmation {
            AccessibilityNotification.Announcement(appText(language, copyConfirmation.english, copyConfirmation.chinese)).post()
        }
    }
}
