import SwiftUI

struct EncoderScreen: View {
    @EnvironmentObject private var deck: CipherDeck
    @State private var plain: String = "MEET ME AT THE OLD MILL"
    @State private var cipher: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    pickerCard
                    plainCard
                    Image(systemName: deck.direction == .encode ? "arrow.down" : "arrow.up")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Palette.accent)
                        .frame(maxWidth: .infinity)
                    cipherCard
                    actionsCard
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(AtelierCanvas(opacity: 0.32, imageName: "Backdrops/bd-loupe"))
            .navigationTitle("tab.encoder")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { recompute() }
        .onChange(of: plain) { _ in recompute() }
        .onChange(of: deck.kind) { _ in recompute() }
        .onChange(of: deck.shift) { _ in recompute() }
        .onChange(of: deck.key) { _ in recompute() }
        .onChange(of: deck.direction) { _ in recompute() }
    }

    private var pickerCard: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 10) {
                Picker("cipher.kind", selection: $deck.kind) {
                    ForEach(CipherKind.allCases) { k in
                        Label(LocalizedStringKey(k.titleKey), systemImage: k.symbol).tag(k)
                    }
                }
                Picker("cipher.dir", selection: $deck.direction) {
                    ForEach(CipherDirection.allCases) { d in
                        Text(LocalizedStringKey(d.titleKey)).tag(d)
                    }
                }
                .pickerStyle(.segmented)
                if deck.kind == .caesar {
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
                if deck.kind == .vigenere {
                    HStack {
                        Image(systemName: "key.fill").foregroundStyle(Palette.accent)
                        TextField("cipher.param.key.placeholder", text: $deck.key)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .font(.system(.body, design: .monospaced).weight(.semibold))
                    }
                }
            }
        }
    }

    private var plainCard: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 6) {
                Text("encoder.input").upperLabel()
                TextEditor(text: $plain)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 100)
            }
        }
    }

    private var cipherCard: some View {
        RoundedCard(tinted: AtelierAccent.surface(for: deck.kind)) {
            VStack(alignment: .leading, spacing: 6) {
                Text("encoder.output").upperLabel()
                Text(cipher.isEmpty ? "—" : cipher)
                    .font(.system(.body, design: .monospaced).weight(.semibold))
                    .foregroundStyle(AtelierAccent.tint(for: deck.kind))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var actionsCard: some View {
        HStack(spacing: 10) {
            Button {
                ClipboardHelper.copy(cipher)
            } label: {
                Label("encoder.copy", systemImage: "doc.on.doc")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Palette.accent, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.white)
            }
            Button {
                deck.remember(source: plain, result: cipher)
                Haptics.success()
            } label: {
                Label("encoder.save", systemImage: "tray.and.arrow.down")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Palette.accentSoft, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(Palette.accent)
            }
        }
    }

    private func recompute() {
        cipher = CipherEngine.transform(text: plain,
                                        kind: deck.kind,
                                        direction: deck.direction,
                                        shift: deck.shift,
                                        key: deck.key)
    }
}
