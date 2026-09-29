import CurveCore
import SwiftUI

enum SquareCurveCategory: CaseIterable {
    case flowersAndOrbits, rollingAndCusps, spiralsAndGrowth, tracesAndOutlines, physicsAndMotion

    static func category(for id: CurveID) -> SquareCurveCategory? {
        switch id {
        case .originalThinking, .thinkingFive, .thinkingNine, .roseOrbit, .roseCurve,
             .roseTwo, .roseThree, .roseFour, .threePetalSpiral, .fourPetalSpiral,
             .fivePetalSpiral, .sixPetalSpiral, .fourierRosette, .gielisBloom, .orbitalPrecession,
             .higherOrderRose, .moireRosette, .asymmetricOrbit, .polarDaisy:
            return .flowersAndOrbits
        case .hypotrochoidLoop, .epicycloid, .hypocycloid, .starTrochoid, .deltoid,
             .nephroid, .heptagonalHypocycloid, .bicorn, .rightStrophoid,
             .cycloidArch, .tschirnhausenCubic, .tenToothSprocket:
            return .rollingAndCusps
        case .spiralSearch, .archimedeanSpiral, .logarithmicSpiral, .eulerSpiral, .goldenAngleSpiral,
             .fermatSpiral, .lituusSpiral, .cochleoid, .circleInvolute,
             .hyperbolicSpiral, .rippleSpiral, .chirpedSpiral:
            return .spiralsAndGrowth
        case .lissajousDrift, .lemniscateBloom, .butterflyPhase, .cardioidGlow, .cardioidHeart,
             .heartWave, .fourierFlow, .superellipse, .lissajousKnot, .harmonograph,
             .fourierDrawing, .lissajousOrbit, .cassiniOval, .maurerRose, .fourierTrefoil,
             .nicomedesConchoid, .superformulaHexagon, .piriform, .descartesFolium,
             .innerLoopLimacon, .cissoidOfDiocles, .witchOfAgnesi, .tractrix,
             .serpentineCurve, .superformulaTriangle, .harmonicStar:
            return .tracesAndOutlines
        case .magneticHelix, .doublePendulum, .lorenzAttractor, .pursuitPolygon,
             .interferenceRing, .chladniRing, .beatOrbit, .dampedPhasePortrait,
             .drivenOscillator, .dipoleFieldLine:
            return .physicsAndMotion
        case .horizontalTravelingWave, .horizontalStandingWave, .verticalTravelingWave, .verticalSpring,
             .horizontalDampedWave, .horizontalChirpWave, .verticalDoubleHelix, .verticalSCurve,
             .horizontalWavePacket, .horizontalSolitaryPulse, .verticalDampedWave, .verticalCatenary:
            return nil
        }
    }
}

struct CurveGroup {
    let title: String
    let curves: [CurveDefinition]
}

struct CurveGalleryView: View {
    @Binding var selection: CurveID?
    @Binding var language: CurveLanguage
    @State private var searchText = ""
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        let definitions = Self.definitions(matching: searchText)
        let groups = Self.groups(for: definitions, language: language)
        List(selection: $selection) {
            ForEach(groups.indices, id: \.self) { index in
                let group = groups[index]
                if !group.curves.isEmpty {
                    Section(group.title) {
                        ForEach(group.curves) { definition in
                            HStack(spacing: 12) {
                                CurveAnimationView(definition: definition,
                                                   parameters: definition.defaultParameters,
                                                   isAnimating: scenePhase == .active)
                                    .frame(width: definition.aspectRatio >= 1 ? 96 : 96 * definition.aspectRatio,
                                           height: definition.aspectRatio >= 1 ? 96 / definition.aspectRatio : 96)
                                    .frame(width: 96, height: 96)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(definition.title(in: language))
                                        .font(.headline)
                                    Text(definition.equation)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            .tag(definition.id)
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $searchText, prompt: appText(language, "Search curves or equations", "搜索曲线或方程"))
        .overlay {
            if definitions.isEmpty {
                ContentUnavailableView(appText(language, "No Results", "无搜索结果"), systemImage: "magnifyingglass",
                                       description: Text(appText(language,
                                                                 "No curves match “\(searchText)”. Try another title, description, or equation.",
                                                                 "没有与“\(searchText)”匹配的曲线。请尝试其他名称、描述或方程。")))
            }
        }
        .navigationTitle(appText(language, "Math Curves", "数学曲线"))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Menu {
                    Button {
                        language = .english
                    } label: {
                        if language == .english {
                            Label("EN", systemImage: "checkmark")
                        } else {
                            Text("EN")
                        }
                    }
                    Button {
                        language = .chinese
                    } label: {
                        if language == .chinese {
                            Label("中文", systemImage: "checkmark")
                        } else {
                            Text("中文")
                        }
                    }
                } label: {
                    Image(systemName: "globe")
                }
                .accessibilityLabel(appText(language, "Language", "语言"))
                .accessibilityHint(appText(language, "Switch between English and Chinese.", "切换英语或中文。"))
            }
        }
    }

    static func definitions(matching query: String) -> [CurveDefinition] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return CurveCatalog.all.filter { definition in
            query.isEmpty || definition.equation.localizedStandardContains(query)
                || CurveLanguage.allCases.contains { language in
                    definition.title(in: language).localizedStandardContains(query)
                        || definition.summary(in: language).localizedStandardContains(query)
                }
        }
    }

    static func groups(for definitions: [CurveDefinition], language: CurveLanguage) -> [CurveGroup] {
        let squareGroups = SquareCurveCategory.allCases.compactMap { category -> CurveGroup? in
            let curves = definitions.filter { SquareCurveCategory.category(for: $0.id) == category }
            guard !curves.isEmpty else { return nil }
            let title = switch category {
            case .flowersAndOrbits: appText(language, "Flowers & Orbits", "花瓣与轨道")
            case .rollingAndCusps: appText(language, "Rolling Curves & Cusps", "滚线与尖点")
            case .spiralsAndGrowth: appText(language, "Spirals & Growth", "螺旋与生长")
            case .tracesAndOutlines: appText(language, "Traces & Outlines", "轨迹与轮廓")
            case .physicsAndMotion: appText(language, "Physics & Motion", "物理与运动")
            }
            return CurveGroup(title: appText(language, "Square · \(title)", "方形 · \(title)"), curves: curves)
        }
        return squareGroups + [
            CurveGroup(title: appText(language, "Horizontal", "横向"), curves: definitions.filter { $0.aspectRatio > 1 }),
            CurveGroup(title: appText(language, "Vertical", "竖向"), curves: definitions.filter { $0.aspectRatio < 1 })
        ]
    }
}
