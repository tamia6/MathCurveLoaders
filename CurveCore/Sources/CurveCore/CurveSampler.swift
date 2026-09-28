import Foundation

public enum CurveSampler {
    /// `phase` is elapsed animation time in seconds and controls the curve's shape.
    public static func samples(for definition: CurveDefinition, parameters: CurveParameters, phase: Double, count: Int) -> [CurvePoint] {
        let count = max(0, count)
        let pulse = detailScale(at: phase, duration: parameters.pulseDuration)
        let wavePhase = wavePhase(at: phase, duration: parameters.pulseDuration)
        return (0..<count).map { index in
            point(for: definition, progress: Double(index) / Double(count), pulse: pulse, wavePhase: wavePhase)
        }
    }

    static func detailScale(at elapsedTime: Double, duration: Double) -> Double {
        let elapsedTime = elapsedTime.isFinite ? elapsedTime : 0
        let cycle = elapsedTime.truncatingRemainder(dividingBy: duration) / duration
        return 0.52 + ((sin(2 * .pi * cycle + 0.55) + 1) / 2) * 0.48
    }

    static func wavePhase(at elapsedTime: Double, duration: Double) -> Double {
        let elapsedTime = elapsedTime.isFinite ? elapsedTime : 0
        return 2 * .pi * (elapsedTime.truncatingRemainder(dividingBy: duration) / duration)
    }

    static func preparePhysicsTrack(for id: CurveID) {
        switch id {
        case .doublePendulum: _ = doublePendulumTrack.count
        case .lorenzAttractor: _ = lorenzTrack.count
        default: break
        }
    }

    static func point(for definition: CurveDefinition, progress: Double, pulse: Double, wavePhase: Double) -> CurvePoint {
        point(for: definition.kind, at: 2 * .pi * progress, pulse: pulse, wavePhase: wavePhase)
    }

    private static func point(for kind: CurveKind, at t: Double, pulse s: Double, wavePhase: Double) -> CurvePoint {
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
        case .epicycloid:
            let scale = 1.45 * (1.05 + 0.1 * s)
            screen = (50 + scale * (21 * cos(t) - 3 * cos(7 * t)),
                      50 + scale * (21 * sin(t) - 3 * sin(7 * t)))
        case .hypocycloid:
            let scale = 1.3 * (0.95 + 0.1 * s)
            screen = (50 + scale * (18 * cos(t) + 6 * cos(3 * t)),
                      50 + scale * (18 * sin(t) - 6 * sin(3 * t)))
        case .starTrochoid:
            let scale = 0.95 + 0.1 * s
            screen = (50 + scale * (20 * cos(t) + 10 * cos(5 * t)),
                      50 + scale * (20 * sin(t) - 10 * sin(5 * t)))
        case .archimedeanSpiral:
            let progress = t / (2 * .pi)
            let angle = 4 * t
            let radius = (2 + 29 * progress) * (0.9 + 0.1 * s)
            screen = (50 + radius * cos(angle), 50 + radius * sin(angle))
        case .logarithmicSpiral:
            let progress = t / (2 * .pi)
            let angle = 4 * t
            let radius = 2 * exp(log(15) * progress) * (0.9 + 0.1 * s)
            screen = (50 + radius * cos(angle), 50 + radius * sin(angle))
        case .superellipse:
            let x = cos(t)
            let y = sin(t)
            let radius = 30 * (0.92 + 0.08 * s)
            screen = (50 + radius * (x < 0 ? -sqrt(abs(x)) : sqrt(x)),
                      50 + radius * (y < 0 ? -sqrt(abs(y)) : sqrt(y)))
        case .lissajousKnot:
            let amplitude = 29 * (0.9 + 0.1 * s)
            screen = (50 + amplitude * sin(5 * t + .pi / 4),
                      50 + amplitude * sin(4 * t))
        case .harmonograph:
            let u = 6 * t
            let amplitude = exp(-0.045 * u) * (0.9 + 0.1 * s)
            screen = (50 + amplitude * (18 * sin(1.05 * u + 0.4) + 10 * sin(1.52 * u)),
                      50 + amplitude * (18 * sin(1.37 * u) + 10 * sin(0.96 * u + 1.1)))
        case .fourierDrawing:
            let scale = 0.92 + 0.08 * s
            screen = (50 + scale * (22 * cos(t) + 7 * cos(-4 * t) + 4 * cos(7 * t)),
                      50 + scale * (22 * sin(t) + 7 * sin(-4 * t) + 4 * sin(7 * t)))
        case .deltoid:
            let scale = 12.2 * (0.9 + 0.1 * s)
            screen = (50 + scale * (2 * cos(t) + cos(2 * t)),
                      50 + scale * (2 * sin(t) - sin(2 * t)))
        case .nephroid:
            let scale = 8.3 * (0.9 + 0.1 * s)
            screen = (50 + scale * (3 * cos(t) - cos(3 * t)),
                      50 + scale * (3 * sin(t) - sin(3 * t)))
        case .heptagonalHypocycloid:
            let scale = 5.2 * (0.9 + 0.1 * s)
            screen = (50 + scale * (6 * cos(t) + cos(6 * t)),
                      50 + scale * (6 * sin(t) - sin(6 * t)))
        case .fourierRosette:
            let radius = (21 + 2 * s) * (0.86 + 0.14 * cos(8 * t + wavePhase)) + 2 * sin(16 * t)
            screen = (50 + radius * cos(t), 50 + radius * sin(t))
        case .lissajousOrbit:
            let amplitude = 27 * (0.9 + 0.1 * s)
            screen = (50 + amplitude * sin(3 * t + .pi / 6),
                      50 + amplitude * sin(5 * t + wavePhase))
        case .orbitalPrecession:
            let eccentricity = 0.62
            let radius = 23 * (0.92 + 0.08 * s) * (1 - eccentricity * eccentricity)
                / (1 + eccentricity * cos(3 * t + wavePhase))
            screen = (50 + radius * cos(t), 50 + radius * sin(t))
        case .magneticHelix:
            let u = t / (2 * .pi)
            let angle = 4 * .pi * u
            let scale = 0.92 + 0.08 * s
            screen = (50 + scale * (18 * cos(angle) + 24 * (u - 0.5)),
                      50 + scale * (14 * sin(angle) - 18 * (u - 0.5)))
        case .doublePendulum:
            let point = interpolatedPoint(in: doublePendulumTrack, progress: t / (2 * .pi))
            let scale = 0.92 + 0.08 * s
            screen = (50 + 50 * scale * point.x, 50 + 50 * scale * point.y)
        case .lorenzAttractor:
            let point = interpolatedPoint(in: lorenzTrack, progress: t / (2 * .pi))
            let scale = 0.92 + 0.08 * s
            screen = (50 + 50 * scale * point.x, 50 + 50 * scale * point.y)
        case .horizontalTravelingWave:
            let u = t / (2 * .pi)
            screen = (8 + 84 * u, 50 + 21 * sin(4 * .pi * u - wavePhase))
        case .horizontalStandingWave:
            let u = t / (2 * .pi)
            screen = (8 + 84 * u, 50 + 23 * sin(3 * .pi * u) * cos(wavePhase))
        case .verticalTravelingWave:
            let u = t / (2 * .pi)
            screen = (50 + 21 * sin(4 * .pi * u - wavePhase), 8 + 84 * u)
        case .verticalSpring:
            let u = t / (2 * .pi)
            screen = (50 + 21 * sin(10 * .pi * u) * sin(.pi * u),
                      50 + (u - 0.5) * (72 + 10 * cos(wavePhase)))
        case .horizontalDampedWave:
            let u = t / (2 * .pi)
            screen = (8 + 84 * u, 50 + 24 * exp(-2.2 * u) * sin(6 * .pi * u - wavePhase))
        case .horizontalChirpWave:
            let u = t / (2 * .pi)
            screen = (8 + 84 * u, 50 + 19 * sin(2 * .pi * (u + 2 * u * u) - wavePhase))
        case .verticalDoubleHelix:
            let u = t / (2 * .pi)
            let firstStrand = u < 0.5
            let v = firstStrand ? 2 * u : 2 - 2 * u
            let direction = firstStrand ? 1.0 : -1.0
            screen = (50 + direction * 18 * sin(4 * .pi * v - wavePhase) * sin(.pi * v),
                      8 + 84 * v)
        case .verticalSCurve:
            let u = t / (2 * .pi)
            screen = (23 + 54 * (3 * u * u - 2 * u * u * u)
                      + 4 * sin(2 * .pi * u - wavePhase) * sin(.pi * u), 8 + 84 * u)
        case .horizontalWavePacket:
            let u = t / (2 * .pi)
            let distance = (u - 0.5) / 0.21
            screen = (8 + 84 * u, 50 + 23 * exp(-distance * distance) * sin(12 * .pi * u - wavePhase))
        case .horizontalSolitaryPulse:
            let u = t / (2 * .pi)
            let center = 0.5 + 0.28 * sin(wavePhase)
            let envelope = cosh(12 * (u - center))
            screen = (8 + 84 * u, 50 + 25 / (envelope * envelope))
        case .verticalDampedWave:
            let u = t / (2 * .pi)
            screen = (50 + 24 * exp(-2.2 * u) * sin(6 * .pi * u - wavePhase), 8 + 84 * u)
        case .verticalCatenary:
            let u = t / (2 * .pi)
            let arc = (cosh(2.4 * (u - 0.5)) - 1) / (cosh(1.2) - 1)
            screen = (18 + (42 + 6 * cos(wavePhase)) * arc, 8 + 84 * u)
        }
        return CurvePoint(x: (screen.0 - 50) / 50, y: (screen.1 - 50) / 50)
    }

    private static func interpolatedPoint(in track: [CurvePoint], progress: Double) -> CurvePoint {
        let position = min(max(progress, 0), 1) * Double(track.count - 1)
        let lower = Int(position)
        let upper = min(lower + 1, track.count - 1)
        let fraction = position - Double(lower)
        return CurvePoint(x: track[lower].x + (track[upper].x - track[lower].x) * fraction,
                          y: track[lower].y + (track[upper].y - track[lower].y) * fraction)
    }

    private static let doublePendulumTrack: [CurvePoint] = {
        let gravity = 9.81
        // Equal masses and lengths are one; state is [θ₁, θ₂, ω₁, ω₂].
        let states = integratedTrack(initial: [2.1, 2.4, 0, 0], steps: 6_000, dt: 0.006) { state in
            let first = state[0], second = state[1]
            let firstVelocity = state[2], secondVelocity = state[3]
            let difference = first - second
            let divisor = 3 - cos(2 * difference)
            let firstAcceleration = (-3 * gravity * sin(first) - gravity * sin(first - 2 * second)
                                     - 2 * sin(difference) * (secondVelocity * secondVelocity
                                     + firstVelocity * firstVelocity * cos(difference))) / divisor
            let secondAcceleration = (2 * sin(difference) * (2 * firstVelocity * firstVelocity
                                      + 2 * gravity * cos(first)
                                      + secondVelocity * secondVelocity * cos(difference))) / divisor
            return [firstVelocity, secondVelocity, firstAcceleration, secondAcceleration]
        }
        return states.map { state in
            CurvePoint(x: 0.42 * (sin(state[0]) + sin(state[1])),
                       y: 0.42 * (cos(state[0]) + cos(state[1])))
        }
    }()

    private static let lorenzTrack: [CurvePoint] = {
        let states = integratedTrack(initial: [0.1, 0, 0], steps: 10_000, dt: 0.005) { state in
            let x = state[0], y = state[1], z = state[2]
            return [10 * (y - x), x * (28 - z) - y, x * y - (8.0 / 3.0) * z]
        }
        return states.dropFirst(1_000).map { state in
            CurvePoint(x: state[0] / 32, y: state[1] / 36)
        }
    }()

    private static func integratedTrack(initial: [Double], steps: Int, dt: Double,
                                        derivative: ([Double]) -> [Double]) -> [[Double]] {
        // Fixed-step RK4 runs once for each static track, never on a Canvas frame.
        var state = initial
        var result = [state]
        result.reserveCapacity(steps + 1)
        for _ in 0..<steps {
            let k1 = derivative(state)
            let k2 = derivative(zip(state, k1).map { $0 + dt * $1 / 2 })
            let k3 = derivative(zip(state, k2).map { $0 + dt * $1 / 2 })
            let k4 = derivative(zip(state, k3).map { $0 + dt * $1 })
            state = state.indices.map { state[$0] + dt * (k1[$0] + 2 * k2[$0] + 2 * k3[$0] + k4[$0]) / 6 }
            result.append(state)
        }
        return result
    }
}
