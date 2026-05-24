import Foundation

enum CipherDirection: String, Codable, CaseIterable, Identifiable {
    case encode
    case decode

    var id: String { rawValue }
    var titleKey: String { "cipher.dir.\(rawValue)" }
}

enum CipherEngine {

    static func transform(text: String,
                          kind: CipherKind,
                          direction: CipherDirection,
                          shift: Int,
                          key: String) -> String {
        switch kind {
        case .caesar:    return caesar(text: text, shift: direction == .encode ? shift : -shift)
        case .vigenere:  return vigenere(text: text, key: key, direction: direction)
        case .atbash:    return atbash(text: text)
        case .polybius:  return direction == .encode ? polybiusEncode(text) : polybiusDecode(text)
        }
    }

    private static func caesar(text: String, shift: Int) -> String {
        let normalShift = ((shift % 26) + 26) % 26
        var result = ""
        for ch in text {
            if let scalar = ch.uppercased().first, scalar.isLetter, let value = scalar.asciiValue, (65...90).contains(Int(value)) {
                let zero = Int(value) - 65
                let shifted = (zero + normalShift) % 26
                let mapped = Character(UnicodeScalar(shifted + 65)!)
                result.append(ch.isUppercase ? mapped : Character(mapped.lowercased()))
            } else {
                result.append(ch)
            }
        }
        return result
    }

    private static func vigenere(text: String, key: String, direction: CipherDirection) -> String {
        let cleanedKey = key.uppercased().filter { $0.isLetter && $0.isASCII }
        guard !cleanedKey.isEmpty else { return text }
        var result = ""
        var keyIdx = 0
        for ch in text {
            if let scalar = ch.uppercased().first, scalar.isLetter, let value = scalar.asciiValue, (65...90).contains(Int(value)) {
                let zero = Int(value) - 65
                let keyChar = cleanedKey[cleanedKey.index(cleanedKey.startIndex, offsetBy: keyIdx % cleanedKey.count)]
                let keyZero = Int(keyChar.asciiValue!) - 65
                let delta = direction == .encode ? keyZero : -keyZero
                let shifted = ((zero + delta) % 26 + 26) % 26
                let mapped = Character(UnicodeScalar(shifted + 65)!)
                result.append(ch.isUppercase ? mapped : Character(mapped.lowercased()))
                keyIdx += 1
            } else {
                result.append(ch)
            }
        }
        return result
    }

    private static func atbash(text: String) -> String {
        var result = ""
        for ch in text {
            if let scalar = ch.uppercased().first, scalar.isLetter, let value = scalar.asciiValue, (65...90).contains(Int(value)) {
                let mirrored = 25 - (Int(value) - 65)
                let mapped = Character(UnicodeScalar(mirrored + 65)!)
                result.append(ch.isUppercase ? mapped : Character(mapped.lowercased()))
            } else {
                result.append(ch)
            }
        }
        return result
    }

    private static func polybiusEncode(_ text: String) -> String {
        var pieces: [String] = []
        for ch in text.uppercased() {
            if let code = PolybiusSquare.code(for: ch) {
                pieces.append(code)
            } else if ch.isWhitespace {
                pieces.append("/")
            } else {
                pieces.append(String(ch))
            }
        }
        return pieces.joined(separator: " ")
    }

    private static func polybiusDecode(_ text: String) -> String {
        let tokens = text.split(separator: " ")
        var result = ""
        for token in tokens {
            if token == "/" { result.append(" "); continue }
            if let letter = PolybiusSquare.letter(for: String(token)) {
                result.append(letter)
            } else {
                result.append(String(token))
            }
        }
        return result
    }
}
