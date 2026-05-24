import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var deck: CipherDeck
    @Environment(\.openURL) private var openURL
    @State private var confirmClear = false

    var body: some View {
        NavigationStack {
            Form {
                Section("settings.section.preferences") {
                    Picker("cipher.param.alphabet", selection: $deck.alphabet) {
                        ForEach(CipherAlphabet.allCases) { alpha in
                            Text(LocalizedStringKey(alpha.titleKey)).tag(alpha)
                        }
                    }
                    Picker("settings.appearance", selection: $deck.appearance) {
                        ForEach(AppearanceMode.allCases) { m in
                            Text(m.label).tag(m)
                        }
                    }
                }

                Section("settings.section.data") {
                    HStack {
                        Label("settings.stats.history", systemImage: "tray")
                        Spacer()
                        Text("\(deck.history.count)").foregroundStyle(.secondary)
                    }
                    Button(role: .destructive) {
                        confirmClear = true
                    } label: {
                        Label("settings.clear", systemImage: "trash")
                    }
                    .disabled(deck.history.isEmpty)
                }

                Section("settings.section.about") {
                    Button {
                        if let url = supportMailURL() { openURL(url) }
                    } label: {
                        Label("settings.support", systemImage: "envelope")
                    }
                    .tint(.primary)
                    NavigationLink {
                        PrivacyWebView()
                    } label: {
                        Label("settings.privacy", systemImage: "hand.raised")
                    }
                    HStack {
                        Label("settings.version", systemImage: "info.circle")
                        Spacer()
                        Text(AppConfig.versionLine).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("tab.reglages")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("settings.clear.confirm",
                                isPresented: $confirmClear,
                                titleVisibility: .visible) {
                Button("settings.clear", role: .destructive) { deck.clearHistory() }
                Button("action.cancel", role: .cancel) {}
            }
        }
    }

    private func supportMailURL() -> URL? {
        let subject = NSLocalizedString("support.subject", comment: "")
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = AppConfig.supportEmail
        c.queryItems = [URLQueryItem(name: "subject", value: subject)]
        return c.url
    }
}
