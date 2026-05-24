import Foundation

struct PolybiusSquare {
    static let layout: [[Character]] = [
        ["A", "B", "C", "D", "E"],
        ["F", "G", "H", "I", "K"],
        ["L", "M", "N", "O", "P"],
        ["Q", "R", "S", "T", "U"],
        ["V", "W", "X", "Y", "Z"]
    ]

    static func code(for letter: Character) -> String? {
        let target: Character = letter == "J" ? "I" : letter
        for (row, line) in layout.enumerated() {
            if let col = line.firstIndex(of: target) {
                return "\(row + 1)\(col + 1)"
            }
        }
        return nil
    }

    static func letter(for code: String) -> Character? {
        guard code.count == 2,
              let row = Int(String(code.first!)),
              let col = Int(String(code.last!)),
              (1...5).contains(row), (1...5).contains(col)
        else { return nil }
        return layout[row - 1][col - 1]
    }
}
