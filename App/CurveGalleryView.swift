import CurveCore
import SwiftUI

struct CurveGalleryView: View {
    @Binding var selection: CurveID?
    @State private var searchText = ""
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        let definitions = Self.definitions(matching: searchText)
        List(selection: $selection) {
            ForEach(definitions) { definition in
                NavigationLink(value: definition.id) {
                    HStack(spacing: 12) {
                        CurveAnimationView(definition: definition,
                                           parameters: definition.defaultParameters,
                                           isAnimating: scenePhase == .active)
                            .frame(width: 44, height: 44)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(definition.title)
                                .font(.headline)
                            Text(definition.equation)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Math Curves")
        .searchable(text: $searchText, prompt: "Search curves or equations")
        .overlay {
            if definitions.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }

    static func definitions(matching query: String) -> [CurveDefinition] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return CurveCatalog.all.filter {
            query.isEmpty || $0.title.localizedStandardContains(query)
                || $0.equation.localizedStandardContains(query)
        }
    }
}
