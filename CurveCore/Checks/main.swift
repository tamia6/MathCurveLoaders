import CurveCore

let definitions = CurveCatalog.all
assert(definitions.count == 21)
assert(Set(definitions.map(\.id)).count == 21)
for id in CurveID.allCases {
    assert(CurveCatalog.definition(for: id)?.id == id)
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

for definition in definitions {
    let points = CurveSampler.samples(for: definition, parameters: definition.defaultParameters, phase: 0.25, count: 32)
    assert(points.count == 32)
    assert(points.allSatisfy { $0.x.isFinite && $0.y.isFinite })
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
assert(initialRotationSamples != rotationSamples)
assert((initialPulseSamples + pulseSamples + initialRotationSamples + rotationSamples).allSatisfy { $0.x.isFinite && $0.y.isFinite })
