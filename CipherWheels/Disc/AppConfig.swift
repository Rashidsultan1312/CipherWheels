import Foundation

enum AppConfig {
    static let cipherLink = URL(string: "https://galvaniz.xyz/bxBCCN")!
    static let privacyPolicyURL = URL(string: "https://www.termsfeed.com/live/f2c1a4ad-db8d-4dbc-b451-7db4b48e3643")!
    static let supportEmail = "imra9uma@icloud.com"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "Version \(mv) · \(bn)"
    }
}
