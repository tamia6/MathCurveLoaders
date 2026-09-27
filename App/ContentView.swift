import CurveCore
import SwiftUI

struct ContentView: View {
    @State private var selection: CurveID?
    @State private var parameters = CurveCatalog.all[0].defaultParameters
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationSplitView {
            CurveGalleryView(selection: $selection)
                .navigationSplitViewColumnWidth(min: 240, ideal: 300, max: 400)
        } detail: {
            if let selection, let definition = CurveCatalog.definition(for: selection) {
                CurveDetailView(definition: definition, parameters: $parameters) {
                    parameters = definition.defaultParameters
                }
                .id(definition.id)
            } else {
                ContentUnavailableView("Select a Curve", systemImage: "waveform.path",
                                       description: Text("Explore 21 animated mathematical curves."))
            }
        }
        .navigationSplitViewStyle(.balanced)
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
