import CurveCore
import SwiftUI

func appText(_ language: CurveLanguage, _ english: String, _ chinese: String) -> String {
    language == .chinese ? chinese : english
}

struct ContentView: View {
    @AppStorage("curveLanguage") private var language: CurveLanguage = .english
    @State private var selection: CurveID?
    @State private var parameters = CurveCatalog.all[0].defaultParameters
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationSplitView {
            CurveGalleryView(selection: $selection, language: $language)
                .navigationSplitViewColumnWidth(min: 240, ideal: 300, max: 400)
        } detail: {
            if let selection, let definition = CurveCatalog.definition(for: selection) {
                CurveDetailView(definition: definition, language: language, parameters: $parameters) {
                    parameters = definition.defaultParameters
                }
                .id(definition.id)
            } else {
                ContentUnavailableView(appText(language, "Select a Curve", "选择曲线"), systemImage: "waveform.path",
                                       description: Text(appText(language,
                                                                 "Explore \(CurveCatalog.all.count) animated mathematical curves.",
                                                                 "探索 \(CurveCatalog.all.count) 种动态数学曲线。")))
            }
        }
        .navigationSplitViewStyle(.balanced)
        .environment(\.locale, Locale(identifier: language.rawValue))
        .onChange(of: selection) { _, newValue in
            if let newValue, let definition = CurveCatalog.definition(for: newValue) {
                parameters = definition.defaultParameters
            }
        }
        .onAppear {
            if horizontalSizeClass != .compact && selection == nil {
                selection = .originalThinking
            }
        }
    }
}
