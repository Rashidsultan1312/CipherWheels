import Foundation

enum AppConfig {
    static let cipherLink = URL(string: "https://keitaro-zaglushka.com")!
    static let privacyPolicyURL = URL(string: "https://hallowtommy.github.io/cipher-wheels-privacy")!
    static let supportEmail = "support@hallowtommy.app"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "Version \(mv) · \(bn)"
    }
}
