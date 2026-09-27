import CurveCore
import SwiftUI

struct CurveGalleryView: View {
    @Binding var selection: CurveID?
    @Binding var language: CurveLanguage
    @State private var searchText = ""
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        let definitions = Self.definitions(matching: searchText)
        VStack(spacing: 0) {
            Picker(appText(language, "Language", "语言"), selection: $language) {
                Text("EN").tag(CurveLanguage.english)
                Text("中文").tag(CurveLanguage.chinese)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)
            .accessibilityLabel(appText(language, "Language", "语言"))
            .accessibilityHint(appText(language, "Switch between English and Chinese.", "切换英语或中文。"))

            List(selection: $selection) {
                ForEach(definitions) { definition in
                    HStack(spacing: 12) {
                        CurveAnimationView(definition: definition,
                                           parameters: definition.defaultParameters,
                                           isAnimating: scenePhase == .active)
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
        }
        .navigationTitle(appText(language, "Math Curves", "数学曲线"))
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
}
