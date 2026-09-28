public enum CurveCatalog {
    public static let all: [CurveDefinition] = [
        define(.originalThinking, "Original Thinking", "x = 50 + 3.9(7 cos t - 3s cos 7t)", "A sevenfold pulsing orbit.", .thinking(7), true, 64, 0.38, 4.6, 4.2, 28, 5.5),
        define(.thinkingFive, "Thinking Five", "x = 50 + 3.9(7 cos t - 3s cos 5t)", "A fivefold pulsing orbit.", .thinking(5), true, 62, 0.38, 4.6, 4.2, 28, 5.5),
        define(.thinkingNine, "Thinking Nine", "x = 50 + 3.9(7 cos t - 3s cos 9t)", "A ninefold pulsing orbit.", .thinking(9), true, 68, 0.39, 4.7, 4.2, 30, 5.5),
        define(.roseOrbit, "Rose Orbit", "r = 7 - 2.7s cos 7t", "A variable-radius polar orbit.", .roseOrbit, true, 72, 0.42, 5.2, 4.6, 28, 5.2),
        define(.roseCurve, "Rose Curve", "r = (9.2 + 0.6s)(0.72 + 0.28s) cos 5t", "A breathing five-petal rose.", .rose(5), true, 78, 0.32, 5.4, 4.6, 28, 4.5),
        define(.roseTwo, "Rose Two", "r = (9.2 + 0.6s)(0.72 + 0.28s) cos 2t", "A breathing two-frequency rose.", .rose(2), true, 74, 0.30, 5.2, 4.3, 28, 4.6),
        define(.roseThree, "Rose Three", "r = (9.2 + 0.6s)(0.72 + 0.28s) cos 3t", "A breathing three-petal rose.", .rose(3), true, 76, 0.31, 5.3, 4.4, 28, 4.6),
        define(.roseFour, "Rose Four", "r = (9.2 + 0.6s)(0.72 + 0.28s) cos 4t", "A breathing four-frequency rose.", .rose(4), true, 78, 0.32, 5.4, 4.5, 28, 4.6),
        define(.lissajousDrift, "Lissajous Drift", "x = 50 + (24 + 6s) sin(3t + 1.57)", "A 3:4 Lissajous trace.", .lissajous, false, 68, 0.34, 6, 5.4, 36, 4.7),
        define(.lemniscateBloom, "Lemniscate Bloom", "x = 50 + a cos t/(1 + sin²t)", "A denominator-pinched figure eight.", .lemniscate, false, 70, 0.40, 5.6, 5, 34, 4.8),
        define(.hypotrochoidLoop, "Hypotrochoid Loop", "x = 50 + 3.05((R-r) cos t + d cos((R-r)t/r))", "An inner rolling-circle loop.", .hypotrochoid, false, 82, 0.46, 7.6, 6.2, 42, 4.6),
        define(.threePetalSpiral, "Three-Petal Spiral", "u = (R-r)(cos t, sin t) + d(cos 2t, -sin 2t)", "A three-loop rolling-circle flower.", .petalSpiral(3), true, 82, 0.34, 4.6, 4.2, 28, 4.4),
        define(.fourPetalSpiral, "Four-Petal Spiral", "u = (R-r)(cos t, sin t) + d(cos 3t, -sin 3t)", "A four-loop rolling-circle flower.", .petalSpiral(4), true, 84, 0.34, 4.6, 4.2, 28, 4.4),
        define(.fivePetalSpiral, "Five-Petal Spiral", "u = (R-r)(cos t, sin t) + d(cos 4t, -sin 4t)", "A five-loop rolling-circle flower.", .petalSpiral(5), true, 85, 0.34, 4.6, 4.2, 28, 4.4),
        define(.sixPetalSpiral, "Six-Petal Spiral", "u = (R-r)(cos t, sin t) + d(cos 5t, -sin 5t)", "A six-loop rolling-circle flower.", .petalSpiral(6), true, 86, 0.34, 4.6, 4.2, 28, 4.4),
        define(.butterflyPhase, "Butterfly Curve", "B(u) = e^cos(u) - 2 cos 4u - sin⁵(u/12)", "A pulsing butterfly parameterization.", .butterfly, false, 88, 0.32, 9, 7, 50, 4.4),
        define(.cardioidGlow, "Cardioid Glow", "r = (8.4 + 0.8s)(1 - cos t)", "An outward glowing cardioid.", .cardioidGlow, false, 72, 0.36, 6.2, 5.2, 36, 4.9),
        define(.cardioidHeart, "Cardioid Heart", "(x, y) = (-r sin t, -r cos t)", "An upright rotated cardioid.", .cardioidHeart, false, 74, 0.36, 6.2, 5.2, 36, 4.9),
        define(.heartWave, "Heart Wave", "f(x) = |x|^(2/3) + 0.9√(3.3 - x²) sin(6.4πx)", "A wave-filled heart envelope.", .heartWave, false, 104, 0.18, 8.4, 5.6, 22, 3.9),
        define(.spiralSearch, "Spiral Search", "r = 8 + (1 - cos t)(8.5 + 2.4s)", "A closed expanding search spiral.", .spiralSearch, false, 86, 0.28, 7.8, 6.8, 44, 4.3),
        define(.fourierFlow, "Fourier Flow", "x = 17 cos t + 7.5 cos(3t + 0.6m) + 3.2 sin(5t - 0.4)", "A pulsing harmonic flow.", .fourierFlow, false, 92, 0.31, 8.4, 6.8, 44, 4.2),
        define(.epicycloid, "Epicycloid", "x = 50 + 1.45(1.05+0.1s)(21 cos t - 3 cos 7t)", "An outer rolling circle with six cusps.", .epicycloid, false, 90, 0.34, 6, 5, 32, 4.4),
        define(.hypocycloid, "Hypocycloid", "x = 50 + 1.3(0.95+0.1s)(18 cos t + 6 cos 3t)", "An inner rolling circle with four cusps.", .hypocycloid, false, 84, 0.33, 6, 5, 32, 4.4),
        define(.starTrochoid, "Star Trochoid", "x = 50 + (0.95+0.1s)(20 cos t + 10 cos 5t)", "An offset inner rolling circle draws a six-point star.", .starTrochoid, false, 94, 0.32, 6.5, 5, 36, 4.2),
        define(.archimedeanSpiral, "Archimedean Spiral", "r = (2+29u)(0.9+0.1s), θ = 8πu", "Radius grows evenly over each turn.", .archimedeanSpiral, false, 100, 0.20, 9, 7, 40, 4),
        define(.logarithmicSpiral, "Logarithmic Spiral", "r = 2e^((ln 15)u)(0.9+0.1s), θ = 8πu", "Radius grows exponentially with angle.", .logarithmicSpiral, false, 100, 0.20, 9, 7, 40, 4),
        define(.superellipse, "Superellipse", "|(x-50)/a|⁴ + |(y-50)/a|⁴ = 1, a = 30(0.92+0.08s)", "A rounded square traced by a power-law curve.", .superellipse, false, 80, 0.30, 7, 5, 32, 4.5),
        define(.lissajousKnot, "Lissajous Knot", "x = 50+a sin(5t+π/4), y = 50+a sin 4t, a = 29(0.9+0.1s)", "A 5:4 Lissajous rhythm with a phase offset.", .lissajousKnot, false, 92, 0.31, 6, 5, 30, 4.5),
        define(.harmonograph, "Harmonograph", "u=6t, A=(0.9+0.1s)e^(-0.045u); x=50+A(18 sin(1.05u+0.4)+10 sin 1.52u); y=50+A(18 sin 1.37u+10 sin(0.96u+1.1))", "Damped harmonics weave an intricate open trace.", .harmonograph, false, 120, 0.16, 10, 8, 40, 3.8),
        define(.fourierDrawing, "Fourier Drawing", "z(t) = (0.92+0.08s)(22e^(it)+7e^(-4it)+4e^(7it))", "Rotating harmonics draw a star-like contour.", .fourierDrawing, false, 96, 0.31, 7.5, 6, 35, 4.2),
        define(.magneticHelix, "Magnetic Helix", "u=t/(2π), a=0.92+0.08s; (X,Y)=(50,50)+a(18cos4πu+24(u−½), 14sin4πu−18(u−½))", "A two-turn 3D helix shown through an oblique projection.", .magneticHelix, false, 120, 0.20, 8, 6, 40, 4),
        define(.doublePendulum, "Double Pendulum", "m₁=m₂=L₁=L₂=1, g=9.81; θ(0)=(2.1,2.4), ω(0)=0; (x₂,y₂)=0.42(sinθ₁+sinθ₂, cosθ₁+cosθ₂)", "The numerically integrated second bob traces a sensitive trajectory.", .doublePendulum, false, 140, 0.14, 10, 8, 45, 3.6),
        define(.lorenzAttractor, "Lorenz Attractor", "ẋ=10(y−x), ẏ=x(28−z)−y, ż=xy−8z/3; (X,Y)=(50,50)+50(0.92+0.08s)(x/32,y/36)", "The standard Lorenz system projected onto the x-y plane.", .lorenzAttractor, false, 140, 0.22, 12, 9, 45, 3.6),
        define(.horizontalTravelingWave, "Traveling Wave · Horizontal", "x=8+84u, y=50+21 sin(4πu−2πτ/T)", "A sine wave travels along a horizontal strip.", .horizontalTravelingWave, false, 96, 0.24, 6, 4, 28, 4, 3),
        define(.horizontalStandingWave, "Standing Wave · Horizontal", "x=8+84u, y=50+23 sin(3πu) cos(2πτ/T)", "Fixed nodes frame an oscillating standing wave.", .horizontalStandingWave, false, 96, 0.24, 6, 4, 28, 4, 3),
        define(.verticalTravelingWave, "Traveling Wave · Vertical", "x=50+21 sin(4πu−2πτ/T), y=8+84u", "A sine wave travels down a vertical strip.", .verticalTravelingWave, false, 96, 0.24, 6, 4, 28, 4, 1.0 / 3),
        define(.verticalSpring, "Vertical Spring", "x=50+21 sin(10πu) sin(πu), y=50+(u−½)(72+10 cos(2πτ/T))", "A coil expands and contracts along a vertical axis.", .verticalSpring, false, 110, 0.22, 6, 4, 28, 3.8, 1.0 / 3),
        define(.horizontalDampedWave, "Damped Wave · Horizontal", "x=8+84u, y=50+24e^(−2.2u)sin(6πu−2πτ/T)", "A wave fades as it travels from left to right.", .horizontalDampedWave, false, 100, 0.25, 6, 4.5, 28, 4, 3),
        define(.horizontalChirpWave, "Chirp Wave · Horizontal", "x=8+84u, y=50+19sin(2π(u+2u²)−2πτ/T)", "Wave spacing tightens across the strip.", .horizontalChirpWave, false, 110, 0.22, 7, 4.5, 28, 3.8, 3),
        define(.verticalDoubleHelix, "Double Helix · Vertical", "x±=50±18sin(4πu−2πτ/T)sin(πu), y=8+84u", "Two strands weave around a shared vertical axis.", .verticalDoubleHelix, false, 120, 0.27, 7, 5, 28, 3.8, 1.0 / 3),
        define(.verticalSCurve, "S Curve · Vertical", "x=23+54(3u²−2u³)+4sin(2πu−2πτ/T)sin(πu), y=8+84u", "A gently shifting S-shaped streamline.", .verticalSCurve, false, 90, 0.28, 7, 6, 28, 4, 1.0 / 3),
    ]

    public static func definition(for id: CurveID) -> CurveDefinition? { all.first { $0.id == id } }

    private static func define(_ id: CurveID, _ title: String, _ equation: String, _ summary: String, _ kind: CurveKind, _ rotates: Bool, _ particleCount: Int, _ trail: Double, _ loop: Double, _ pulse: Double, _ rotation: Double, _ stroke: Double, _ aspectRatio: Double = 1) -> CurveDefinition {
        CurveDefinition(id: id, title: title, equation: equation, summary: summary, defaultParameters: .init(particleCount: particleCount, trail: trail, loopDuration: loop, pulseDuration: pulse, rotationDuration: rotation, strokeWidth: stroke), rotates: rotates, aspectRatio: aspectRatio, kind: kind)
    }
}
