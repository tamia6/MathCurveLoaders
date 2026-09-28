import SwiftUI

public struct CurveAnimationView: View {
    public let definition: CurveDefinition
    public let parameters: CurveParameters
    public let isAnimating: Bool

    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
    @State private var preparedCurveID: CurveID?

    public init(definition: CurveDefinition, parameters: CurveParameters, isAnimating: Bool = true) {
        self.definition = definition
        self.parameters = parameters
        self.isAnimating = isAnimating
    }

    public var body: some View {
        Group {
            if needsPreparation && preparedCurveID != definition.id {
                Color.clear
            } else if isAnimating && !accessibilityReduceMotion {
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        draw(in: context, size: size, elapsedTime: timeline.date.timeIntervalSinceReferenceDate)
                    }
                }
            } else {
                Canvas { context, size in
                    draw(in: context, size: size, elapsedTime: 0)
                }
            }
        }
        .background(Color(white: 0.055))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .task(id: definition.id) {
            guard needsPreparation else { return }
            let id = definition.id
            // ponytail: shared tracks finish warming after view cancellation; revisit if integration grows.
            await Task.detached(priority: .userInitiated) {
                CurveSampler.preparePhysicsTrack(for: id)
            }.value
            guard !Task.isCancelled else { return }
            preparedCurveID = id
        }
    }

    private var needsPreparation: Bool {
        definition.id == .doublePendulum || definition.id == .lorenzAttractor
    }

    private func draw(in context: GraphicsContext, size: CGSize, elapsedTime: Double) {
        let side = min(size.width, size.height)
        guard side > 2 else { return }

        let scale = side / 100
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let pulse = CurveSampler.detailScale(at: elapsedTime, duration: parameters.pulseDuration)
        let rotation = definition.rotates ? -2 * Double.pi * (elapsedTime.truncatingRemainder(dividingBy: parameters.rotationDuration) / parameters.rotationDuration) : 0
        let cosine = cos(rotation)
        let sine = sin(rotation)
        func canvasPoint(_ point: CurvePoint) -> CGPoint {
            CGPoint(
                x: center.x + (point.x * cosine - point.y * sine) * side / 2,
                y: center.y + (point.x * sine + point.y * cosine) * side / 2
            )
        }

        let integratedTrack = definition.id == .doublePendulum || definition.id == .lorenzAttractor
        let segments = integratedTrack ? 3_200 : 480
        var curve = Path()
        for step in 0...segments {
            let point = CurveSampler.point(for: definition, progress: Double(step) / Double(segments), pulse: pulse)
            let position = canvasPoint(point)
            if step == 0 { curve.move(to: position) } else { curve.addLine(to: position) }
        }
        context.stroke(curve, with: .color(.white.opacity(0.1)), style: StrokeStyle(
            lineWidth: parameters.strokeWidth * scale * (integratedTrack ? 0.35 : 1),
            lineCap: .round, lineJoin: .round
        ))

        let progress = (elapsedTime / parameters.loopDuration).truncatingRemainder(dividingBy: 1)
        if integratedTrack {
            var trail = Path()
            var previous = -1.0
            let steps = max(480, parameters.particleCount * 4)
            for step in 0...steps {
                let phase = progress - parameters.trail + parameters.trail * Double(step) / Double(steps)
                let wrapped = phase - floor(phase)
                let position = canvasPoint(CurveSampler.point(for: definition, progress: wrapped, pulse: pulse))
                if step == 0 || wrapped < previous { trail.move(to: position) } else { trail.addLine(to: position) }
                previous = wrapped
            }
            context.stroke(trail, with: .color(.white.opacity(0.8)), style: StrokeStyle(
                lineWidth: parameters.strokeWidth * scale * 0.5, lineCap: .round, lineJoin: .round
            ))
        }

        let count = parameters.particleCount
        for index in 0..<count {
            let offset = Double(index) / Double(count - 1)
            let phase = progress - offset * parameters.trail
            let wrapped = phase - floor(phase)
            let point = CurveSampler.point(for: definition, progress: wrapped, pulse: pulse)
            let position = canvasPoint(point)
            let fade = pow(1 - offset, 0.56)
            let radius = integratedTrack
                ? (0.15 + fade * 0.4) * parameters.strokeWidth * scale * 0.5
                : (0.9 + fade * 2.7) * scale * 1.35
            let circle = Path(ellipseIn: CGRect(x: position.x - radius, y: position.y - radius,
                                                width: radius * 2, height: radius * 2))
            context.fill(circle, with: .color(.white.opacity(0.04 + fade * 0.96)))
        }
    }
}
