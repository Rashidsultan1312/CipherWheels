import SwiftUI

struct CipherFactCard: View {
    let titleKey: LocalizedStringKey
    let bodyKey: LocalizedStringKey

    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 4) {
                Text(titleKey).font(.headline)
                Text(bodyKey)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
