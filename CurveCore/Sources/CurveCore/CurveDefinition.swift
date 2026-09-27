public enum CurveID: String, CaseIterable, Identifiable, Sendable {
    case originalThinking, thinkingFive, thinkingNine, roseOrbit, roseCurve, roseTwo, roseThree, roseFour
    case lissajousDrift, lemniscateBloom, hypotrochoidLoop, threePetalSpiral, fourPetalSpiral
    case fivePetalSpiral, sixPetalSpiral, butterflyPhase, cardioidGlow, cardioidHeart, heartWave
    case spiralSearch, fourierFlow

    public var id: Self { self }
}

public struct CurveParameters: Equatable, Sendable {
    public let particleCount: Int
    public let trail: Double
    public let loopDuration: Double
    public let pulseDuration: Double
    public let rotationDuration: Double
    public let strokeWidth: Double

    public init(particleCount: Int, trail: Double, loopDuration: Double, pulseDuration: Double, rotationDuration: Double, strokeWidth: Double) {
        self.particleCount = min(max(particleCount, 24), 140)
        self.trail = Self.clamp(trail, 0.12...0.68)
        self.loopDuration = Self.clamp(loopDuration, 2.4...12)
        self.pulseDuration = Self.clamp(pulseDuration, 1.8...10)
        self.rotationDuration = Self.clamp(rotationDuration, 6...60)
        self.strokeWidth = Self.clamp(strokeWidth, 2.5...7.5)
    }

    private static func clamp(_ value: Double, _ range: ClosedRange<Double>) -> Double {
        if value.isNaN { return range.lowerBound }
        guard value.isFinite else { return value.sign == .minus ? range.lowerBound : range.upperBound }
        return min(max(value, range.lowerBound), range.upperBound)
    }
}

enum CurveKind: Sendable {
    case originalThinking, thinkingFive, thinkingNine, rose(Int), lissajous, lemniscate, hypotrochoid
    case petalSpiral(Int), butterfly, cardioidGlow, cardioidHeart, heart, spiral, fourier
}

public struct CurveDefinition: Identifiable, Sendable {
    public let id: CurveID
    public let title: String
    public let equation: String
    public let summary: String
    public let defaultParameters: CurveParameters
    let kind: CurveKind

    init(id: CurveID, title: String, equation: String, summary: String, defaultParameters: CurveParameters, kind: CurveKind) {
        self.id = id
        self.title = title
        self.equation = equation
        self.summary = summary
        self.defaultParameters = defaultParameters
        self.kind = kind
    }
}

public struct CurvePoint: Equatable, Sendable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
