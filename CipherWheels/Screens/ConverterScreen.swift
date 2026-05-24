import SwiftUI

struct WheelScreen: View {
    @EnvironmentObject private var deck: CipherDeck
    @State private var source: String = "RENDEZ VOUS A MINUIT"
    @State private var output: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    kindPicker
                    directionToggle
                    visualizationCard
                    parametersCard
                    sourceCard
                    outputCard
                    samplesCard
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(AtelierCanvas(opacity: 0.35, imageName: AtelierBackdrop.named(for: deck.kind)))
            .navigationTitle("tab.wheel")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { recompute() }
        .onChange(of: deck.kind) { _ in recompute() }
        .onChange(of: deck.direction) { _ in recompute() }
        .onChange(of: deck.shift) { _ in recompute() }
        .onChange(of: deck.key) { _ in recompute() }
        .onChange(of: source) { _ in recompute() }
    }

    private var kindPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CipherKind.allCases) { kind in
                    ChipButton(LocalizedStringKey(kind.titleKey),
                               symbol: kind.symbol,
                               selected: kind == deck.kind,
                               tint: AtelierAccent.tint(for: kind)) {
                        deck.kind = kind
                    }
                }
            }
        }
    }

    private var directionToggle: some View {
        Picker("cipher.dir", selection: $deck.direction) {
            ForEach(CipherDirection.allCases) { dir in
                Text(LocalizedStringKey(dir.titleKey)).tag(dir)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var visualizationCard: some View {
        switch deck.kind {
        case .caesar:    CaesarLadder(shift: deck.shift)
        case .vigenere:  VigenereLadder(key: deck.key)
        case .atbash:    AtbashMirror()
        case .polybius:  PolybiusGrid()
        }
    }

    @ViewBuilder
    private var parametersCard: some View {
        if deck.kind == .caesar {
            RoundedCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("cipher.param.shift").upperLabel()
                    Stepper(value: $deck.shift, in: 0...25) {
                        HStack {
                            Text("cipher.param.shift.label")
                            Spacer()
                            Text("\(deck.shift)")
                                .font(.system(.title3, design: .monospaced).weight(.bold))
                                .foregroundStyle(Palette.accent)
                        }
                    }
                }
            }
        } else if deck.kind == .vigenere {
            RoundedCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("cipher.param.key").upperLabel()
                    TextField("cipher.param.key.placeholder", text: $deck.key)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .font(.system(.body, design: .monospaced).weight(.semibold))
                }
            }
        }
    }

    private var sourceCard: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("cipher.source.title").upperLabel()
                    Spacer()
                    if !source.isEmpty {
                        Button { source = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                TextEditor(text: $source)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 80)
            }
        }
    }

    private var outputCard: some View {
        RoundedCard(tinted: AtelierAccent.surface(for: deck.kind)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(deck.direction == .encode ? "cipher.output.cipher" : "cipher.output.plain")
                        .upperLabel()
                    Spacer()
                    Button {
                        ClipboardHelper.copy(output)
                    } label: {
                        Label("cipher.output.copy", systemImage: "doc.on.doc")
                            .font(.caption.weight(.semibold))
                    }
                }
                Text(output.isEmpty ? "—" : output)
                    .font(.system(.body, design: .monospaced).weight(.semibold))
                    .foregroundStyle(AtelierAccent.tint(for: deck.kind))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    deck.remember(source: source, result: output)
                    Haptics.success()
                } label: {
                    Label("cipher.save", systemImage: "tray.and.arrow.down")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.borderless)
            }
        }
    }

    private var samplesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("cipher.samples.title")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CipherSampleCatalog.all) { sample in
                        ChipButton(LocalizedStringKey(sample.titleKey),
                                   symbol: "play.fill",
                                   tint: AtelierAccent.tint(for: sample.kind)) {
                            deck.kind = sample.kind
                            if sample.kind == .caesar { deck.shift = sample.shift }
                            if sample.kind == .vigenere && !sample.key.isEmpty { deck.key = sample.key }
                            source = sample.plaintext
                            deck.direction = .encode
                        }
                    }
                }
            }
        }
    }

    private func recompute() {
        output = CipherEngine.transform(text: source,
                                        kind: deck.kind,
                                        direction: deck.direction,
                                        shift: deck.shift,
                                        key: deck.key)
    }
}

private let alphabet: [String] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }

private struct CaesarLadder: View {
    let shift: Int

    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("cipher.kind.caesar.sub")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        ladderRow(letters: alphabet,
                                  highlightIdx: 0,
                                  tint: Palette.bordeaux,
                                  labelKey: "ladder.plain")
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(Palette.wornGold)
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 56)
                        ladderRow(letters: shifted,
                                  highlightIdx: 0,
                                  tint: Palette.wornGold,
                                  labelKey: "ladder.cipher")
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxWidth: .infinity)
                Text(String(format: NSLocalizedString("ladder.example.caesar", comment: ""),
                            "A",
                            shifted[0]))
                    .font(.system(.subheadline, design: .serif).italic())
                    .foregroundStyle(Palette.bordeaux)
            }
        }
    }

    private var shifted: [String] {
        let s = ((shift % 26) + 26) % 26
        var arr: [String] = []
        for i in 0..<26 {
            arr.append(alphabet[(i + s) % 26])
        }
        return arr
    }

    @ViewBuilder
    private func ladderRow(letters: [String],
                           highlightIdx: Int,
                           tint: Color,
                           labelKey: String) -> some View {
        HStack(spacing: 0) {
            Text(LocalizedStringKey(labelKey))
                .font(.system(.caption, design: .serif).weight(.bold))
                .foregroundStyle(.secondary)
                .frame(width: 56, alignment: .leading)
            ForEach(Array(letters.enumerated()), id: \.offset) { idx, letter in
                Text(letter)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundStyle(idx == highlightIdx ? .white : tint)
                    .frame(width: 26, height: 32)
                    .background(
                        idx == highlightIdx
                            ? AnyView(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(tint))
                            : AnyView(Color.clear)
                    )
            }
        }
    }
}

private struct VigenereLadder: View {
    let key: String

    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("cipher.kind.vigenere.sub")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                HStack(alignment: .center, spacing: 14) {
                    Image(systemName: "key.fill")
                        .font(.title)
                        .foregroundStyle(Palette.wornGold)
                    Text(displayKey)
                        .font(.system(.title, design: .serif).weight(.heavy))
                        .foregroundStyle(Palette.bordeaux)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Palette.parchment.opacity(0.6))
                )
                ladderLine
                Text(L("cipher.disc.hint.vigenere"))
                    .font(.system(.caption, design: .serif).italic())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var displayKey: String {
        key.isEmpty ? "—" : key.uppercased()
    }

    private var ladderLine: some View {
        HStack(spacing: 4) {
            ForEach(0..<min(displayKey.count, 9), id: \.self) { idx in
                let ch = Array(displayKey)[idx]
                VStack(spacing: 4) {
                    Text(String(ch))
                        .font(.system(.headline, design: .serif).weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Palette.bordeaux))
                    Text("+\(shift(for: ch))")
                        .font(.system(.caption2, design: .monospaced).weight(.bold))
                        .foregroundStyle(.secondary)
                }
            }
            if displayKey.count > 9 {
                Text("…")
                    .font(.system(.title2, design: .serif))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func shift(for ch: Character) -> Int {
        guard let v = ch.uppercased().first?.asciiValue, (65...90).contains(Int(v)) else { return 0 }
        return Int(v) - 65
    }
}

private struct AtbashMirror: View {
    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("cipher.kind.atbash.sub")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                pairRow(top: "A", bottom: "Z")
                pairRow(top: "B", bottom: "Y")
                pairRow(top: "C", bottom: "X")
                pairRow(top: "D", bottom: "W")
                HStack {
                    Spacer()
                    Text("…")
                        .font(.system(.title, design: .serif))
                        .foregroundStyle(Palette.bordeaux.opacity(0.5))
                    Spacer()
                }
                Text(L("cipher.disc.hint.mirror"))
                    .font(.system(.caption, design: .serif).italic())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func pairRow(top: String, bottom: String) -> some View {
        HStack(spacing: 18) {
            Spacer()
            Text(top)
                .font(.system(.title2, design: .serif).weight(.bold))
                .foregroundStyle(Palette.bordeaux)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Palette.parchment))
                .overlay(Circle().stroke(Palette.bordeaux.opacity(0.5), lineWidth: 1))
            Image(systemName: "arrow.left.arrow.right")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Palette.wornGold)
            Text(bottom)
                .font(.system(.title2, design: .serif).weight(.bold))
                .foregroundStyle(Palette.bordeaux)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Palette.parchment))
                .overlay(Circle().stroke(Palette.bordeaux.opacity(0.5), lineWidth: 1))
            Spacer()
        }
    }
}

private struct PolybiusGrid: View {
    private let grid: [[String]] = [
        ["A", "B", "C", "D", "E"],
        ["F", "G", "H", "I/J", "K"],
        ["L", "M", "N", "O", "P"],
        ["Q", "R", "S", "T", "U"],
        ["V", "W", "X", "Y", "Z"]
    ]

    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("cipher.kind.polybius.sub")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Text(" ").frame(width: 36)
                        ForEach(1...5, id: \.self) { col in
                            Text("\(col)")
                                .font(.system(.caption, design: .monospaced).weight(.bold))
                                .foregroundStyle(.secondary)
                                .frame(width: 36)
                        }
                    }
                    ForEach(0..<5, id: \.self) { row in
                        HStack(spacing: 6) {
                            Text("\(row + 1)")
                                .font(.system(.caption, design: .monospaced).weight(.bold))
                                .foregroundStyle(.secondary)
                                .frame(width: 36)
                            ForEach(0..<5, id: \.self) { col in
                                Text(grid[row][col])
                                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                                    .foregroundStyle(Palette.bordeaux)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .fill(Palette.parchment.opacity(0.6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .stroke(Palette.wornGold.opacity(0.5), lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Text(L("cipher.disc.hint.polybius"))
                    .font(.system(.caption, design: .serif).italic())
                    .foregroundStyle(.secondary)
            }
        }
    }
}
