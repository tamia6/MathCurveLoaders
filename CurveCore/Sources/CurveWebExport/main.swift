import CurveCore
import Foundation

// The website interpolates these samples; formulas remain in CurveCore.
let frames = 48
let points = 480
let output = URL(fileURLWithPath: CommandLine.arguments.dropFirst().first ?? "web/data", isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
var catalog: [[String: Any]] = []
for definition in CurveCatalog.all {
    let p = definition.defaultParameters
    let sampleCount = [.doublePendulum, .lorenzAttractor].contains(definition.id) ? 3_200 : points
    var data = Data()
    for frame in 0..<frames {
        let samples = CurveSampler.samples(for: definition, parameters: p,
                                           phase: p.pulseDuration * Double(frame) / Double(frames), count: sampleCount)
        for point in samples {
            for value in [point.x, point.y] {
                guard value.isFinite else { fatalError("Non-finite sample: \(definition.id)") }
                var bits = Float(value).bitPattern.littleEndian
                withUnsafeBytes(of: &bits) { data.append(contentsOf: $0) }
            }
        }
    }
    try data.write(to: output.appendingPathComponent("\(definition.id.rawValue).bin"), options: .atomic)
    catalog.append([
        "id": definition.id.rawValue, "title": definition.title,
        "zhTitle": definition.title(in: .chinese), "summary": definition.summary,
        "zhSummary": definition.summary(in: .chinese), "equation": definition.equation,
        "ratio": definition.aspectRatio, "rotates": definition.rotates,
        "points": sampleCount,
        "parameters": ["particleCount": Double(p.particleCount), "trail": p.trail,
                       "loopDuration": p.loopDuration, "pulseDuration": p.pulseDuration,
                       "rotationDuration": p.rotationDuration, "strokeWidth": p.strokeWidth]
    ])
}
let manifest: [String: Any] = ["frames": frames, "points": points, "curves": catalog]
try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted, .sortedKeys])
    .write(to: output.appendingPathComponent("catalog.json"), options: .atomic)
print("Exported \(catalog.count) curves to \(output.path)")
