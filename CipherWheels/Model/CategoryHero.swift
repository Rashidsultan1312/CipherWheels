import Foundation

enum AtelierBackdrop {
    static let names: [String] = [
        "Backdrops/bd-scroll",
        "Backdrops/bd-quill",
        "Backdrops/bd-seal-wax",
        "Backdrops/bd-loupe",
        "Backdrops/bd-glyph-ring",
        "Backdrops/bd-diagram-circle",
        "Backdrops/bd-abacus",
        "Backdrops/bd-parchment",
        "Backdrops/bd-ink-pot",
        "Backdrops/bd-codex",
        "Backdrops/bd-roman-numerals",
        "Backdrops/bd-atbash-grid",
        "Backdrops/bd-mirror-letter",
        "Backdrops/bd-key-ring"
    ]

    static let primary = "Backdrops/bd-scroll"

    static func named(forIndex index: Int) -> String {
        let safe = ((index % names.count) + names.count) % names.count
        return names[safe]
    }

    static func named(for kind: CipherKind) -> String {
        switch kind {
        case .caesar:   return "Backdrops/bd-roman-numerals"
        case .vigenere: return "Backdrops/bd-key-ring"
        case .atbash:   return "Backdrops/bd-mirror-letter"
        case .polybius: return "Backdrops/bd-atbash-grid"
        }
    }
}
