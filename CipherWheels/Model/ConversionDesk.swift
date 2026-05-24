import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable, Codable {
    case system
    case dark
    case light

    var id: String { rawValue }

    var label: LocalizedStringKey {
        switch self {
        case .system: return "appearance.system"
        case .dark:   return "appearance.dark"
        case .light:  return "appearance.light"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .dark:   return .dark
        case .light:  return .light
        }
    }
}

struct CipherEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var sourceText: String
    var resultText: String
    var kind: CipherKind
    var direction: CipherDirection
    var shift: Int
    var key: String
    var savedAt: Date

    init(id: UUID = UUID(),
         sourceText: String,
         resultText: String,
         kind: CipherKind,
         direction: CipherDirection,
         shift: Int,
         key: String,
         savedAt: Date = Date()) {
        self.id = id
        self.sourceText = sourceText
        self.resultText = resultText
        self.kind = kind
        self.direction = direction
        self.shift = shift
        self.key = key
        self.savedAt = savedAt
    }
}

@MainActor
final class CipherDeck: ObservableObject {
    @Published var kind: CipherKind = .caesar { didSet { persistPrefs() } }
    @Published var direction: CipherDirection = .encode { didSet { persistPrefs() } }
    @Published var shift: Int = 3 { didSet { persistPrefs() } }
    @Published var key: String = "MARIE" { didSet { persistPrefs() } }
    @Published var alphabet: CipherAlphabet = .latinFR { didSet { persistPrefs() } }
    @Published var appearance: AppearanceMode = .system { didSet { persistPrefs() } }
    @Published var history: [CipherEntry] = [] { didSet { persistHistory() } }

    private let defaults = UserDefaults.standard
    private let kKind = "cw.pref.kind"
    private let kDir = "cw.pref.dir"
    private let kShift = "cw.pref.shift"
    private let kKey = "cw.pref.key"
    private let kAlpha = "cw.pref.alpha"
    private let kAppearance = "cw.pref.appearance"
    private let kHistory = "cw.log.history"

    init() { restore() }

    func remember(source: String, result: String) {
        let entry = CipherEntry(sourceText: source,
                                resultText: result,
                                kind: kind,
                                direction: direction,
                                shift: shift,
                                key: key)
        var bag = history
        bag.insert(entry, at: 0)
        if bag.count > 20 { bag = Array(bag.prefix(20)) }
        history = bag
    }

    func clearHistory() { history = [] }

    func remove(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
    }

    private func persistPrefs() {
        defaults.set(kind.rawValue, forKey: kKind)
        defaults.set(direction.rawValue, forKey: kDir)
        defaults.set(shift, forKey: kShift)
        defaults.set(key, forKey: kKey)
        defaults.set(alphabet.rawValue, forKey: kAlpha)
        defaults.set(appearance.rawValue, forKey: kAppearance)
    }

    private func persistHistory() {
        if let data = try? JSONEncoder().encode(history) {
            defaults.set(data, forKey: kHistory)
        }
    }

    private func restore() {
        if let raw = defaults.string(forKey: kKind), let kk = CipherKind(rawValue: raw) { kind = kk }
        if let raw = defaults.string(forKey: kDir), let dd = CipherDirection(rawValue: raw) { direction = dd }
        if let raw = defaults.string(forKey: kAlpha), let aa = CipherAlphabet(rawValue: raw) { alphabet = aa }
        if let raw = defaults.string(forKey: kAppearance), let mm = AppearanceMode(rawValue: raw) { appearance = mm }
        let storedShift = defaults.integer(forKey: kShift)
        if storedShift != 0 { shift = storedShift }
        if let stored = defaults.string(forKey: kKey), !stored.isEmpty { key = stored }
        if let data = defaults.data(forKey: kHistory),
           let decoded = try? JSONDecoder().decode([CipherEntry].self, from: data) {
            history = decoded
        }
    }
}
