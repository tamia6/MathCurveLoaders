import Foundation

public enum CurveSampler {
    /// `phase` is elapsed animation time in seconds. It drives the pulse and rotation durations.
    public static func samples(for definition: CurveDefinition, parameters: CurveParameters, phase: Double, count: Int) -> [CurvePoint] {
        let count = max(0, count)
        let elapsedTime = phase.isFinite ? phase : 0
        let pulseCycle = cycle(elapsedTime, duration: parameters.pulseDuration)
        let rotation = 2 * Double.pi * cycle(elapsedTime, duration: parameters.rotationDuration)
        let pulse = 0.875 + 0.125 * sin(2 * Double.pi * pulseCycle)
        return (0..<count).map { index in
            let t = 2 * Double.pi * Double(index) / Double(max(count, 1))
            let point = point(for: definition.kind, at: t, pulse: pulse)
            return CurvePoint(
                x: pulse * (point.x * cos(rotation) - point.y * sin(rotation)),
                y: pulse * (point.x * sin(rotation) + point.y * cos(rotation))
            )
        }
    }

    private static func cycle(_ elapsedTime: Double, duration: Double) -> Double {
        (elapsedTime / duration).truncatingRemainder(dividingBy: 1)
    }

    private static func point(for kind: CurveKind, at t: Double, pulse: Double) -> CurvePoint {
        let raw: (Double, Double, Double)
        switch kind {
        case .originalThinking: raw = thinking(t, 7, pulse)
        case .thinkingFive: raw = thinking(t, 5, pulse)
        case .thinkingNine: raw = thinking(t, 9, pulse)
        case .rose(let petals):
            let r = cos(Double(petals) * t)
            raw = (r * cos(t), r * sin(t), 1)
        case .lissajous: raw = (sin(3 * t), sin(2 * t + .pi / 2), 1)
        case .lemniscate:
            let r = sqrt(abs(cos(2 * t)))
            raw = (r * cos(t), r * sin(t), 1)
        case .hypotrochoid: raw = (5 * cos(t) + 2 * cos(3 * t), 5 * sin(t) - 2 * sin(3 * t), 7)
        case .petalSpiral(let petals):
            let r = (t / (2 * .pi)) * sin(Double(petals) * t)
            raw = (r * cos(t), r * sin(t), 1)
        case .butterfly:
            let r = exp(sin(t)) - 2 * cos(4 * t) - pow(sin(t / 12), 5)
            raw = (r * sin(t), r * cos(t), 5)
        case .cardioidGlow:
            let r = 1 - cos(t)
            raw = (r * cos(t), r * sin(t), 2)
        case .cardioidHeart:
            let r = 1 + cos(t)
            raw = (r * cos(t), r * sin(t), 2)
        case .heart:
            raw = (16 * pow(sin(t), 3), 13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t), 18)
        case .spiral:
            let r = t / (2 * .pi)
            raw = (r * cos(t), r * sin(t), 1)
        case .fourier: raw = (cos(t) + cos(3 * t) / 3, sin(t) + sin(2 * t) / 2, 1.5)
        }
        return CurvePoint(x: raw.0 / raw.2, y: raw.1 / raw.2)
    }

    private static func thinking(_ t: Double, _ petals: Int, _ pulse: Double) -> (Double, Double, Double) {
        let n = Double(petals)
        return (7 * cos(t) - 3 * pulse * cos(n * t), 7 * sin(t) - 3 * pulse * sin(n * t), 10)
    }
}
