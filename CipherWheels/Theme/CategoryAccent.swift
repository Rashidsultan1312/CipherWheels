import SwiftUI

enum AtelierAccent {
    static func tint(for kind: CipherKind) -> Color {
        switch kind {
        case .caesar:   return Color(red: 0.58, green: 0.18, blue: 0.18)
        case .vigenere: return Color(red: 0.46, green: 0.30, blue: 0.55)
        case .atbash:   return Color(red: 0.32, green: 0.43, blue: 0.36)
        case .polybius: return Color(red: 0.74, green: 0.51, blue: 0.21)
        }
    }

    static func surface(for kind: CipherKind) -> Color {
        tint(for: kind).opacity(0.13)
    }
}
