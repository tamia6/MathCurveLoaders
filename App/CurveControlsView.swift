import CurveCore
import SwiftUI

struct CurveControlsView: View {
    let definition: CurveDefinition
    @Binding var parameters: CurveParameters
    let reset: () -> Void

    var body: some View {
        Section("Animation Parameters") {
            // CurveCore applies all six parameters to every catalog definition.
            Stepper("Particle count: \(parameters.particleCount)", value: particleCount, in: 24...140)
                .accessibilityLabel("Particle count")
                .accessibilityValue("\(parameters.particleCount)")
            slider("Trail length", keyPath: \.trail, range: 0.12...0.68, step: 0.01, unit: "")
            slider("Loop duration", keyPath: \.loopDuration, range: 2.4...12, step: 0.1, unit: "seconds")
            slider("Pulse duration", keyPath: \.pulseDuration, range: 1.8...10, step: 0.1, unit: "seconds")
            slider("Rotation duration", keyPath: \.rotationDuration, range: 6...60, step: 1, unit: "seconds")
            slider("Stroke width", keyPath: \.strokeWidth, range: 2.5...7.5, step: 0.1, unit: "points")
            Button("Reset to Defaults", action: reset)
                .disabled(parameters == definition.defaultParameters)
                .accessibilityHint("Restores the default parameters for \(definition.title).")
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
