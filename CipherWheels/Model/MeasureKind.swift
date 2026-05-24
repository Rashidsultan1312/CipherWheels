import SwiftUI

enum CipherKind: String, CaseIterable, Codable, Identifiable {
    case caesar
    case vigenere
    case atbash
    case polybius

    var id: String { rawValue }

    var titleKey: String { "cipher.kind.\(rawValue)" }
    var subtitleKey: String { "cipher.kind.\(rawValue).sub" }
    var lessonKey: String { "cipher.lesson.\(rawValue)" }
    var inventorKey: String { "cipher.inventor.\(rawValue)" }
    var yearKey: String { "cipher.year.\(rawValue)" }

    var requiresKey: Bool { self == .vigenere }
    var requiresShift: Bool { self == .caesar }

    var symbol: String {
        switch self {
        case .caesar: return "arrow.triangle.2.circlepath"
        case .vigenere: return "key.fill"
        case .atbash: return "arrow.left.arrow.right.square"
        case .polybius: return "square.grid.5x3"
        }
    }
}

enum CipherAlphabet: String, CaseIterable, Codable, Identifiable {
    case latinFR
    case latinEN

    var id: String { rawValue }

    var letters: [Character] {
        Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }

    var titleKey: String { "cipher.alpha.\(rawValue)" }
}
