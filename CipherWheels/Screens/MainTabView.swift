import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            WheelScreen()
                .tabItem { Label("tab.wheel", systemImage: "circle.grid.cross.fill") }
                .tag(0)
            EncoderScreen()
                .tabItem { Label("tab.encoder", systemImage: "key.fill") }
                .tag(1)
            HistoireScreen()
                .tabItem { Label("tab.histoire", systemImage: "clock") }
                .tag(2)
            LeconsScreen()
                .tabItem { Label("tab.lecons", systemImage: "graduationcap.fill") }
                .tag(3)
            SettingsScreen()
                .tabItem { Label("tab.reglages", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .tint(Palette.accent)
    }
}
