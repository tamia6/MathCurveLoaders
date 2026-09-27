public enum CurveCatalog {
    public static let all: [CurveDefinition] = [
        definition(.originalThinking, "Original Thinking", "x = 7 cos t - 3s cos 7t; y = 7 sin t - 3s sin 7t", "A pulsing sevenfold trail.", .originalThinking),
        definition(.thinkingFive, "Thinking Five", "x = 7 cos t - 3s cos 5t; y = 7 sin t - 3s sin 5t", "A pulsing fivefold trail.", .thinkingFive),
        definition(.thinkingNine, "Thinking Nine", "x = 7 cos t - 3s cos 9t; y = 7 sin t - 3s sin 9t", "A pulsing ninefold trail.", .thinkingNine),
        definition(.roseOrbit, "Rose Orbit", "r = cos 7t", "A seven-petal polar rose.", .rose(7)),
        definition(.roseCurve, "Rose Curve", "r = sin 5t", "A five-petal polar rose.", .rose(5)),
        definition(.roseTwo, "Rose Two", "r = cos 2t", "A four-petal rose.", .rose(2)),
        definition(.roseThree, "Rose Three", "r = cos 3t", "A three-petal rose.", .rose(3)),
        definition(.roseFour, "Rose Four", "r = cos 4t", "An eight-petal rose.", .rose(4)),
        definition(.lissajousDrift, "Lissajous Drift", "x = sin 3t; y = sin(2t + π/2)", "A drifting 3:2 Lissajous curve.", .lissajous),
        definition(.lemniscateBloom, "Lemniscate Bloom", "r² = cos 2t", "A blooming figure-eight.", .lemniscate),
        definition(.hypotrochoidLoop, "Hypotrochoid Loop", "x = 5 cos t + 2 cos 3t; y = 5 sin t - 2 sin 3t", "A rolling inner-wheel loop.", .hypotrochoid),
        definition(.threePetalSpiral, "Three Petal Spiral", "r = t sin 3t", "A three-petal expanding spiral.", .petalSpiral(3)),
        definition(.fourPetalSpiral, "Four Petal Spiral", "r = t sin 4t", "A four-petal expanding spiral.", .petalSpiral(4)),
        definition(.fivePetalSpiral, "Five Petal Spiral", "r = t sin 5t", "A five-petal expanding spiral.", .petalSpiral(5)),
        definition(.sixPetalSpiral, "Six Petal Spiral", "r = t sin 6t", "A six-petal expanding spiral.", .petalSpiral(6)),
        definition(.butterflyPhase, "Butterfly Phase", "r = e^(sin t) - 2 cos 4t - sin⁵(t/12)", "A phased butterfly curve.", .butterfly),
        definition(.cardioidGlow, "Cardioid Glow", "r = 1 - cos t", "A glowing inward cardioid.", .cardioidGlow),
        definition(.cardioidHeart, "Cardioid Heart", "r = 1 + cos t", "A rounded heart-like cardioid.", .cardioidHeart),
        definition(.heartWave, "Heart Wave", "x = 16 sin³t; y = 13 cos t - 5 cos 2t - 2 cos 3t - cos 4t", "A classic parametric heart.", .heart),
        definition(.spiralSearch, "Spiral Search", "r = t / 2π", "An outward searching spiral.", .spiral),
        definition(.fourierFlow, "Fourier Flow", "x = cos t + cos 3t / 3; y = sin t + sin 2t / 2", "A compact harmonic flow.", .fourier),
    ]

    public static func definition(for id: CurveID) -> CurveDefinition? {
        all.first { $0.id == id }
    }

    private static func definition(_ id: CurveID, _ title: String, _ equation: String, _ summary: String, _ kind: CurveKind) -> CurveDefinition {
        CurveDefinition(id: id, title: title, equation: equation, summary: summary, defaultParameters: .init(particleCount: 64, trail: 0.38, loopDuration: 4.6, pulseDuration: 4.2, rotationDuration: 28, strokeWidth: 5.5), kind: kind)
    }
}
