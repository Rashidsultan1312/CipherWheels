import SwiftUI

struct HistoireScreen: View {
    @EnvironmentObject private var deck: CipherDeck
    @State private var filter: CipherKind? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    summaryCard
                    filterStrip
                    if filtered.isEmpty {
                        EmptyStateBox(symbol: "clock.arrow.circlepath",
                                      titleKey: "histoire.empty.title",
                                      messageKey: "histoire.empty.body")
                    } else {
                        VStack(spacing: 12) {
                            ForEach(filtered) { entry in
                                HistoireRow(entry: entry)
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(AtelierCanvas(opacity: 0.32, imageName: "Backdrops/bd-codex"))
            .navigationTitle("tab.histoire")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var filtered: [CipherEntry] {
        guard let filter else { return deck.history }
        return deck.history.filter { $0.kind == filter }
    }

    private var summaryCard: some View {
        HStack(spacing: 12) {
            StatBadge(titleKey: "histoire.stat.saved",
                      value: "\(deck.history.count)",
                      symbol: "tray.fill",
                      tint: Palette.accent)
            StatBadge(titleKey: "histoire.stat.kinds",
                      value: "\(Set(deck.history.map(\.kind)).count)",
                      symbol: "square.grid.2x2.fill",
                      tint: Palette.wornGold)
        }
    }

    private var filterStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("histoire.filter.title")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ChipButton("histoire.filter.all",
                               symbol: filter == nil ? "checkmark" : nil,
                               selected: filter == nil) { filter = nil }
                    ForEach(CipherKind.allCases) { kind in
                        ChipButton(LocalizedStringKey(kind.titleKey),
                                   symbol: filter == kind ? "checkmark" : nil,
                                   selected: filter == kind,
                                   tint: AtelierAccent.tint(for: kind)) {
                            filter = filter == kind ? nil : kind
                        }
                    }
                }
            }
        }
    }
}

private struct HistoireRow: View {
    let entry: CipherEntry

    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: entry.kind.symbol)
                        .foregroundStyle(AtelierAccent.tint(for: entry.kind))
                        .padding(8)
                        .background(AtelierAccent.surface(for: entry.kind), in: Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey(entry.kind.titleKey))
                            .font(.subheadline.weight(.bold))
                        Text(LocalizedStringKey(entry.direction.titleKey))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(entry.savedAt, style: .date)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Text(entry.sourceText)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(entry.resultText)
                    .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                    .lineLimit(2)
            }
        }
    }
}
