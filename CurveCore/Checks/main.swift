import CurveCore

let definitions = CurveCatalog.all
assert(definitions.count == CurveID.allCases.count)
assert(Set(definitions.map(\.id)).count == CurveID.allCases.count)
for id in CurveID.allCases {
    assert(CurveCatalog.definition(for: id)?.id == id)
}
for definition in definitions {
    assert(!definition.title(in: .chinese).isEmpty)
    assert(!definition.summary(in: .chinese).isEmpty)
    assert(definition.title(in: .chinese) != definition.title(in: .english))
}

let parameters = CurveParameters(
    particleCount: -1,
    trail: -.infinity,
    loopDuration: -.infinity,
    pulseDuration: .infinity,
    rotationDuration: .nan,
    strokeWidth: .infinity
)
assert(parameters.particleCount == 24)
assert(parameters.trail == 0.12)
assert(parameters.loopDuration == 2.4)
assert(parameters.pulseDuration == 10)
assert(parameters.rotationDuration == 6)
assert(parameters.strokeWidth == 7.5)

let expectedDefaults: [(CurveID, Int, Double, Double, Double, Double, Double, Bool)] = [
    (.originalThinking, 64, 0.38, 4.6, 4.2, 28, 5.5, true),
    (.thinkingFive, 62, 0.38, 4.6, 4.2, 28, 5.5, true),
    (.thinkingNine, 68, 0.39, 4.7, 4.2, 30, 5.5, true),
    (.roseOrbit, 72, 0.42, 5.2, 4.6, 28, 5.2, true),
    (.roseCurve, 78, 0.32, 5.4, 4.6, 28, 4.5, true),
    (.roseTwo, 74, 0.30, 5.2, 4.3, 28, 4.6, true),
    (.roseThree, 76, 0.31, 5.3, 4.4, 28, 4.6, true),
    (.roseFour, 78, 0.32, 5.4, 4.5, 28, 4.6, true),
    (.lissajousDrift, 68, 0.34, 6, 5.4, 36, 4.7, false),
    (.lemniscateBloom, 70, 0.40, 5.6, 5, 34, 4.8, false),
    (.hypotrochoidLoop, 82, 0.46, 7.6, 6.2, 42, 4.6, false),
    (.threePetalSpiral, 82, 0.34, 4.6, 4.2, 28, 4.4, true),
    (.fourPetalSpiral, 84, 0.34, 4.6, 4.2, 28, 4.4, true),
    (.fivePetalSpiral, 85, 0.34, 4.6, 4.2, 28, 4.4, true),
    (.sixPetalSpiral, 86, 0.34, 4.6, 4.2, 28, 4.4, true),
    (.butterflyPhase, 88, 0.32, 9, 7, 50, 4.4, false),
    (.cardioidGlow, 72, 0.36, 6.2, 5.2, 36, 4.9, false),
    (.cardioidHeart, 74, 0.36, 6.2, 5.2, 36, 4.9, false),
    (.heartWave, 104, 0.18, 8.4, 5.6, 22, 3.9, false),
    (.spiralSearch, 86, 0.28, 7.8, 6.8, 44, 4.3, false),
    (.fourierFlow, 92, 0.31, 8.4, 6.8, 44, 4.2, false),
    (.epicycloid, 90, 0.34, 6, 5, 32, 4.4, false),
    (.hypocycloid, 84, 0.33, 6, 5, 32, 4.4, false),
    (.starTrochoid, 94, 0.32, 6.5, 5, 36, 4.2, false),
    (.archimedeanSpiral, 100, 0.20, 9, 7, 40, 4, false),
    (.logarithmicSpiral, 100, 0.20, 9, 7, 40, 4, false),
    (.superellipse, 80, 0.30, 7, 5, 32, 4.5, false),
    (.lissajousKnot, 92, 0.31, 6, 5, 30, 4.5, false),
    (.harmonograph, 120, 0.16, 10, 8, 40, 3.8, false),
    (.fourierDrawing, 96, 0.31, 7.5, 6, 35, 4.2, false),
]
for (id, count, trail, loop, pulse, rotation, width, rotates) in expectedDefaults {
    let definition = CurveCatalog.definition(for: id)!
    assert(definition.defaultParameters == CurveParameters(particleCount: count, trail: trail, loopDuration: loop, pulseDuration: pulse, rotationDuration: rotation, strokeWidth: width))
    assert(definition.rotates == rotates)
}

func assertPoint(_ id: CurveID, count: Int, x: Double, y: Double) {
    let definition = CurveCatalog.definition(for: id)!
    let point = CurveSampler.samples(for: definition, parameters: definition.defaultParameters, phase: 0, count: count)[0]
    assert(abs(point.x - x) < 0.000_000_1)
    assert(abs(point.y - y) < 0.000_000_1)
}

assertPoint(.roseOrbit, count: 4, x: 0.35952529670092870, y: 0)
assertPoint(.lemniscateBloom, count: 4, x: 0.52396229089207003, y: 0)
assertPoint(.hypotrochoidLoop, count: 4, x: 0.66880910577365849, y: 0)
assertPoint(.cardioidHeart, count: 4, x: 0, y: -0.81771861152410308)
assertPoint(.heartWave, count: 2, x: -0.84289785858074173, y: -0.50507652194220443)
assertPoint(.spiralSearch, count: 4, x: 0.16, y: 0)
assertPoint(.fourierFlow, count: 4, x: 0.43123982561771868, y: -0.030107531157960353)

for definition in definitions {
    let points = CurveSampler.samples(for: definition, parameters: definition.defaultParameters, phase: 0.25, count: 32)
    assert(points.count == 32)
    assert(points.allSatisfy { $0.x.isFinite && $0.y.isFinite })
}

let newIDs: [CurveID] = [.epicycloid, .hypocycloid, .starTrochoid, .archimedeanSpiral,
                         .logarithmicSpiral, .superellipse, .lissajousKnot, .harmonograph,
                         .fourierDrawing, .deltoid, .nephroid, .heptagonalHypocycloid,
                         .fourierRosette, .lissajousOrbit, .orbitalPrecession, .cassiniOval,
                         .gielisBloom, .maurerRose, .eulerSpiral, .goldenAngleSpiral, .pursuitPolygon,
                         .fermatSpiral, .lituusSpiral, .fourierTrefoil, .interferenceRing,
                         .chladniRing, .higherOrderRose, .bicorn, .cochleoid,
                         .nicomedesConchoid, .superformulaHexagon, .piriform,
                         .descartesFolium, .innerLoopLimacon, .rightStrophoid,
                         .circleInvolute, .hyperbolicSpiral, .cissoidOfDiocles,
                         .witchOfAgnesi, .tractrix, .serpentineCurve, .cycloidArch,
                         .tschirnhausenCubic, .superformulaTriangle, .harmonicStar,
                         .rippleSpiral, .chirpedSpiral, .tenToothSprocket, .moireRosette,
                         .asymmetricOrbit, .polarDaisy, .beatOrbit, .dampedPhasePortrait,
                         .drivenOscillator, .dipoleFieldLine]
for id in newIDs {
    let definition = CurveCatalog.definition(for: id)!
    assert(definition.aspectRatio == 1)
    let points = CurveSampler.samples(for: definition, parameters: definition.defaultParameters, phase: 1, count: 480)
    let xs = points.map(\.x)
    let ys = points.map(\.y)
    assert(xs.max()! - xs.min()! > 0.2)
    assert(ys.max()! - ys.min()! > 0.2)
    let maximum = points.map { max(abs($0.x), abs($0.y)) }.max()!
    assert(maximum < 1, "\(id) maximum coordinate is \(maximum)")
}
for id in [CurveID.archimedeanSpiral, .logarithmicSpiral] {
    let definition = CurveCatalog.definition(for: id)!
    let points = CurveSampler.samples(for: definition, parameters: definition.defaultParameters, phase: 1, count: 480)
    assert(abs(points[0].x - points[479].x) > 0.2)
}

for phase in [Double.greatestFiniteMagnitude, -Double.greatestFiniteMagnitude, Double.nan, Double.infinity] {
    for definition in definitions {
        let points = CurveSampler.samples(for: definition, parameters: definition.defaultParameters, phase: phase, count: 32)
        assert(points.allSatisfy { $0.x.isFinite && $0.y.isFinite })
    }
}

let cardioidGlow = CurveCatalog.definition(for: .cardioidGlow)!
let cardioidHeart = CurveCatalog.definition(for: .cardioidHeart)!
assert(CurveSampler.samples(for: cardioidGlow, parameters: cardioidGlow.defaultParameters, phase: 0, count: 8) != CurveSampler.samples(for: cardioidHeart, parameters: cardioidHeart.defaultParameters, phase: 0, count: 8))

let staticDefinition = CurveCatalog.definition(for: .originalThinking)!
let staticParameters = staticDefinition.defaultParameters
let staticRenderer = CurveAnimationView(definition: staticDefinition, parameters: staticParameters, isAnimating: false)
assert(!staticRenderer.isAnimating)

let animatedDefinition = CurveCatalog.definition(for: .spiralSearch)!
let pulseParameters = CurveParameters(
    particleCount: animatedDefinition.defaultParameters.particleCount,
    trail: animatedDefinition.defaultParameters.trail,
    loopDuration: animatedDefinition.defaultParameters.loopDuration,
    pulseDuration: 8,
    rotationDuration: 6,
    strokeWidth: animatedDefinition.defaultParameters.strokeWidth
)
let rotationParameters = CurveParameters(
    particleCount: animatedDefinition.defaultParameters.particleCount,
    trail: animatedDefinition.defaultParameters.trail,
    loopDuration: animatedDefinition.defaultParameters.loopDuration,
    pulseDuration: 2,
    rotationDuration: 8,
    strokeWidth: animatedDefinition.defaultParameters.strokeWidth
)
let initialPulseSamples = CurveSampler.samples(for: animatedDefinition, parameters: pulseParameters, phase: 0, count: pulseParameters.particleCount)
let pulseSamples = CurveSampler.samples(for: animatedDefinition, parameters: pulseParameters, phase: pulseParameters.rotationDuration, count: pulseParameters.particleCount)
let initialRotationSamples = CurveSampler.samples(for: animatedDefinition, parameters: rotationParameters, phase: 0, count: rotationParameters.particleCount)
let rotationSamples = CurveSampler.samples(for: animatedDefinition, parameters: rotationParameters, phase: rotationParameters.pulseDuration, count: rotationParameters.particleCount)
assert(initialPulseSamples != pulseSamples)
assert(initialRotationSamples == rotationSamples)
assert((initialPulseSamples + pulseSamples + initialRotationSamples + rotationSamples).allSatisfy { $0.x.isFinite && $0.y.isFinite })
