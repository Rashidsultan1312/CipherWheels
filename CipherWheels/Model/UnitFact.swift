import Foundation

struct CipherLesson: Identifiable, Hashable {
    var id: String { kind.rawValue }
    let kind: CipherKind
    let bodyKey: String
    let exampleKey: String
}

enum CipherLessonCatalog {
    static let all: [CipherLesson] = [
        .init(kind: .caesar,   bodyKey: "lesson.caesar.body",   exampleKey: "lesson.caesar.example"),
        .init(kind: .vigenere, bodyKey: "lesson.vigenere.body", exampleKey: "lesson.vigenere.example"),
        .init(kind: .atbash,   bodyKey: "lesson.atbash.body",   exampleKey: "lesson.atbash.example"),
        .init(kind: .polybius, bodyKey: "lesson.polybius.body", exampleKey: "lesson.polybius.example")
    ]

    static func lesson(for kind: CipherKind) -> CipherLesson {
        all.first(where: { $0.kind == kind }) ?? all[0]
    }
}
