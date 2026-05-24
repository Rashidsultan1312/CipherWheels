import SwiftUI

@main
struct CipherWheelsApp: App {
    @StateObject private var deck = CipherDeck()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(deck)
                .preferredColorScheme(deck.appearance.colorScheme)
                .tint(Palette.accent)
        }
    }
}
