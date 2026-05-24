import Foundation

struct CipherSample: Identifiable, Hashable {
    var id: String { titleKey }
    let titleKey: String
    let plaintext: String
    let kind: CipherKind
    let shift: Int
    let key: String
}

enum CipherSampleCatalog {
    static let all: [CipherSample] = [
        .init(titleKey: "sample.caesar.basic",
              plaintext: "VENI VIDI VICI",
              kind: .caesar, shift: 3, key: ""),
        .init(titleKey: "sample.caesar.rot13",
              plaintext: "GRAVITY FALLS",
              kind: .caesar, shift: 13, key: ""),
        .init(titleKey: "sample.vigenere.marie",
              plaintext: "RENDEZ VOUS A MINUIT",
              kind: .vigenere, shift: 0, key: "MARIE"),
        .init(titleKey: "sample.atbash.hebrew",
              plaintext: "BABYLON",
              kind: .atbash, shift: 0, key: ""),
        .init(titleKey: "sample.polybius.classic",
              plaintext: "HISTORIA",
              kind: .polybius, shift: 0, key: ""),
        .init(titleKey: "sample.vigenere.book",
              plaintext: "MEET ME AT THE OLD MILL",
              kind: .vigenere, shift: 0, key: "ROUE")
    ]
}
