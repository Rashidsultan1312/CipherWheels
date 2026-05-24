import SwiftUI

struct DiscConsentPanel: View {
    let scroll: URL
    let onTurn: () -> Void
    @State private var ringed = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("gate.welcome.title")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }
                .padding(.top, 28)

                DiscFrame(circle: scroll, sterile: true)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)

                Button(action: { ringed.toggle() }) {
                    HStack(spacing: 12) {
                        Image(systemName: ringed ? "circle.inset.filled" : "circle")
                            .font(.system(size: 22))
                            .foregroundStyle(ringed ? Color.accentColor : Color.secondary)
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 18)

                Button(action: onTurn) {
                    Text("gate.privacy.continue")
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!ringed)
                .opacity(ringed ? 1 : 0.4)
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
