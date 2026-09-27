import CurveCore
import SwiftUI

struct CurveControlsView: View {
    let definition: CurveDefinition
    let language: CurveLanguage
    @Binding var parameters: CurveParameters
    let reset: () -> Void

    var body: some View {
        Section(appText(language, "Animation Parameters", "动画参数")) {
            Stepper(appText(language, "Particle count: \(parameters.particleCount)", "粒子数量：\(parameters.particleCount)"), value: particleCount, in: 24...140)
                .accessibilityLabel(appText(language, "Particle count", "粒子数量"))
                .accessibilityValue("\(parameters.particleCount)")
            slider(appText(language, "Trail length", "拖尾长度"), keyPath: \.trail, range: 0.12...0.68, step: 0.01, unit: "")
            slider(appText(language, "Loop duration", "循环时长"), keyPath: \.loopDuration, range: 2.4...12, step: 0.1, unit: appText(language, "seconds", "秒"))
            slider(appText(language, "Pulse duration", "脉动时长"), keyPath: \.pulseDuration, range: 1.8...10, step: 0.1, unit: appText(language, "seconds", "秒"))
            if definition.rotates {
                slider(appText(language, "Rotation duration", "旋转时长"), keyPath: \.rotationDuration, range: 6...60, step: 1, unit: appText(language, "seconds", "秒"))
            }
            slider(appText(language, "Stroke width", "线条宽度"), keyPath: \.strokeWidth, range: 2.5...7.5, step: 0.1, unit: "")
            Button(appText(language, "Reset to Defaults", "恢复默认设置"), action: reset)
                .disabled(parameters == definition.defaultParameters)
                .accessibilityHint(appText(language,
                                           "Restores the default parameters for \(definition.title(in: .english)).",
                                           "恢复“\(definition.title(in: .chinese))”的默认参数。"))
        }
    }

    private func slider(_ title: String, keyPath: KeyPath<CurveParameters, Double>,
                        range: ClosedRange<Double>, step: Double, unit: String) -> some View {
        let value = parameters[keyPath: keyPath].formatted(.number.precision(.fractionLength(0...2)))
        return VStack(alignment: .leading) {
            LabeledContent(title, value: unit.isEmpty ? value : "\(value) \(unit)")
            Slider(value: binding(for: keyPath), in: range, step: step) {
                Text(title)
            }
            .accessibilityValue(unit.isEmpty ? value : "\(value) \(unit)")
        }
    }

    var particleCount: Binding<Int> {
        Binding(get: { parameters.particleCount }, set: { parameters = parameters.replacing(particleCount: $0) })
    }

    func binding(for keyPath: KeyPath<CurveParameters, Double>) -> Binding<Double> {
        Binding(get: { parameters[keyPath: keyPath] }, set: { value in
            parameters = parameters.replacing(
                trail: keyPath == \.trail ? value : nil,
                loopDuration: keyPath == \.loopDuration ? value : nil,
                pulseDuration: keyPath == \.pulseDuration ? value : nil,
                rotationDuration: keyPath == \.rotationDuration ? value : nil,
                strokeWidth: keyPath == \.strokeWidth ? value : nil
            )
        })
    }
}

private extension CurveParameters {
    func replacing(particleCount: Int? = nil, trail: Double? = nil, loopDuration: Double? = nil,
                   pulseDuration: Double? = nil, rotationDuration: Double? = nil, strokeWidth: Double? = nil) -> Self {
        Self(particleCount: particleCount ?? self.particleCount, trail: trail ?? self.trail,
             loopDuration: loopDuration ?? self.loopDuration, pulseDuration: pulseDuration ?? self.pulseDuration,
             rotationDuration: rotationDuration ?? self.rotationDuration, strokeWidth: strokeWidth ?? self.strokeWidth)
    }
}
