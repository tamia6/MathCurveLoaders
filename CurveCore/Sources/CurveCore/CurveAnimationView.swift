import SwiftUI

public struct CurveAnimationView: View {
    public let definition: CurveDefinition
    public let parameters: CurveParameters
    public let isAnimating: Bool

    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion

    public init(definition: CurveDefinition, parameters: CurveParameters, isAnimating: Bool = true) {
        self.definition = definition
        self.parameters = parameters
        self.isAnimating = isAnimating
    }

    public var body: some View {
        if isAnimating && !accessibilityReduceMotion {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    draw(in: context, size: size, phase: animatedPhase(at: timeline.date))
                }
            }
        } else {
            Canvas { context, size in
                draw(in: context, size: size, phase: 0)
            }
        }
    }

    private func animatedPhase(at date: Date) -> Double {
        return (date.timeIntervalSinceReferenceDate / parameters.loopDuration).truncatingRemainder(dividingBy: 1)
    }

    private func draw(in context: GraphicsContext, size: CGSize, phase: Double) {
        let smallestSide = min(size.width, size.height)
        guard smallestSide > 2 else { return }

        let samples = CurveSampler.samples(
            for: definition,
            parameters: parameters,
            phase: 0,
            count: parameters.particleCount
        )
        guard !samples.isEmpty else { return }

        let lineWidth = min(parameters.strokeWidth, (smallestSide - 2) / 1.6)
        let radius = lineWidth * 0.8
        let inset = max(lineWidth / 2, radius) + 1
        let bounds = CGRect(origin: .zero, size: size).insetBy(dx: inset, dy: inset)
        let points = samples.map { point in
            CGPoint(
                x: bounds.minX + ((point.x.clamped(to: -1...1) + 1) / 2) * bounds.width,
                y: bounds.minY + ((1 - point.y.clamped(to: -1...1)) / 2) * bounds.height
            )
        }

        var curve = Path()
        curve.move(to: points[0])
        for point in points.dropFirst() { curve.addLine(to: point) }
        context.stroke(curve, with: .color(.accentColor.opacity(0.3)), lineWidth: lineWidth)

        let start = Int(phase * Double(points.count)) % points.count
        let length = max(2, Int(Double(points.count) * parameters.trail))
        var trail = Path()
        trail.move(to: points[start])
        for offset in 1..<length {
            let index = (start + offset) % points.count
            if index == 0 { trail.move(to: points[index]) } else { trail.addLine(to: points[index]) }
        }
        context.stroke(trail, with: .color(.accentColor), lineWidth: lineWidth)

        let marker = points[(start + length - 1) % points.count]
        context.fill(Path(ellipseIn: CGRect(x: marker.x - radius, y: marker.y - radius, width: radius * 2, height: radius * 2)), with: .color(.accentColor))
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
