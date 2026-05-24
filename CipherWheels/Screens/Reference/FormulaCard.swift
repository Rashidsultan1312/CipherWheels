import SwiftUI

struct SampleCard: View {
    let sample: CipherSample

    var body: some View {
        RoundedCard(tinted: AtelierAccent.surface(for: sample.kind)) {
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStringKey(sample.titleKey))
                    .font(.subheadline.weight(.bold))
                Text(sample.plaintext)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                if sample.kind == .caesar {
                    Text(String(format: NSLocalizedString("sample.caesar.shift", comment: ""), sample.shift))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AtelierAccent.tint(for: sample.kind))
                } else if sample.kind == .vigenere {
                    Text(String(format: NSLocalizedString("sample.vigenere.key", comment: ""), sample.key))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AtelierAccent.tint(for: sample.kind))
                }
            }
        }
    }
}
