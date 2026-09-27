import Foundation

public enum CurveSampler {
    /// `phase` is elapsed animation time in seconds and controls the curve pulse.
    public static func samples(for definition: CurveDefinition, parameters: CurveParameters, phase: Double, count: Int) -> [CurvePoint] {
        let count = max(0, count)
        let pulse = detailScale(at: phase, duration: parameters.pulseDuration)
        return (0..<count).map { index in
            point(for: definition.kind, at: 2 * .pi * Double(index) / Double(max(count, 1)), pulse: pulse)
        }
    }

    private static func detailScale(at elapsedTime: Double, duration: Double) -> Double {
        let elapsedTime = elapsedTime.isFinite ? elapsedTime : 0
        let cycle = elapsedTime.truncatingRemainder(dividingBy: duration) / duration
        return 0.52 + ((sin(2 * .pi * cycle + 0.55) + 1) / 2) * 0.48
    }

    private static func point(for kind: CurveKind, at t: Double, pulse s: Double) -> CurvePoint {
        let screen: (Double, Double)
        switch kind {
        case .thinking(let petals):
            screen = (50 + (7 * cos(t) - 3 * s * cos(Double(petals) * t)) * 3.9, 50 + (7 * sin(t) - 3 * s * sin(Double(petals) * t)) * 3.9)
        case .roseOrbit:
            let r = 7 - 2.7 * s * cos(7 * t)
            screen = (50 + cos(t) * r * 3.9, 50 + sin(t) * r * 3.9)
        case .rose(let petals):
            let a = 9.2 + 0.6 * s
            let r = a * (0.72 + 0.28 * s) * cos(Double(petals) * t)
            screen = (50 + cos(t) * r * 3.25, 50 + sin(t) * r * 3.25)
        case .lissajous:
            let a = 24 + 6 * s
            screen = (50 + sin(3 * t + 1.57) * a, 50 + sin(4 * t) * a * 0.92)
        case .lemniscate:
            let a = 20 + 7 * s
            let denominator = 1 + pow(sin(t), 2)
            screen = (50 + a * cos(t) / denominator, 50 + a * sin(t) * cos(t) / denominator)
        case .hypotrochoid:
            let r = 2.7 + 0.45 * s
            let d = 4.8 + 1.2 * s
            let factor = (8.2 - r) / r
            screen = (50 + ((8.2 - r) * cos(t) + d * cos(factor * t)) * 3.05, 50 + ((8.2 - r) * sin(t) - d * sin(factor * t)) * 3.05)
        case .petalSpiral(let radius):
            let r = Double(radius)
            let d = 3 + 0.25 * s
            let factor = r - 1
            let scale = 2.2 + 0.45 * s
            screen = (50 + (factor * cos(t) + d * cos(factor * t)) * scale, 50 + (factor * sin(t) - d * sin(factor * t)) * scale)
        case .butterfly:
            let u = t * 6
            let shape = exp(cos(u)) - 2 * cos(4 * u) - pow(sin(u / 12), 5)
            let scale = 4.6 + 0.45 * s
            screen = (50 + sin(u) * shape * scale, 50 + cos(u) * shape * scale)
        case .cardioidGlow:
            let r = (8.4 + 0.8 * s) * (1 - cos(t))
            screen = (50 + cos(t) * r * 2.15, 50 + sin(t) * r * 2.15)
        case .cardioidHeart:
            let r = (8.8 + 0.8 * s) * (1 + cos(t))
            screen = (50 - sin(t) * r * 2.15, 50 - cos(t) * r * 2.15)
        case .heartWave:
            let limit = sqrt(3.3)
            let x = -limit + (t / (2 * .pi)) * 2 * limit
            let wave = 0.9 * sqrt(max(0, 3.3 - x * x)) * sin(6.4 * .pi * x)
            let y = pow(abs(x), 2 / 3) + wave
            screen = (50 + x * 23.2, 18 + (1.75 - y) * (24.5 + 1.5 * s))
        case .spiralSearch:
            let angle = 4 * t
            let r = 8 + (1 - cos(t)) * (8.5 + 2.4 * s)
            screen = (50 + cos(angle) * r, 50 + sin(angle) * r)
        case .fourierFlow:
            let mix = 1 + 0.16 * s
            screen = (50 + 17 * cos(t) + 7.5 * cos(3 * t + 0.6 * mix) + 3.2 * sin(5 * t - 0.4), 50 + 15 * sin(t) + 8.2 * sin(2 * t + 0.25) - 4.2 * cos(4 * t - 0.5 * mix))
        }
        return CurvePoint(x: (screen.0 - 50) / 50, y: (screen.1 - 50) / 50)
    }
}
