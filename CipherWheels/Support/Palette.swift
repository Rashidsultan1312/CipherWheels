import SwiftUI

enum Palette {
    static let accent = Color("AccentColor")
    static let accentSoft = Color("AccentColor").opacity(0.14)

    static var cardFill: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    static var chipFill: Color {
        Color(uiColor: .tertiarySystemFill)
    }

    static var canvas: Color {
        Color(uiColor: .systemGroupedBackground)
    }

    static let parchment = Color(red: 0.96, green: 0.92, blue: 0.83)
    static let wornGold = Color(red: 0.79, green: 0.66, blue: 0.30)
    static let bordeaux = Color(red: 0.58, green: 0.18, blue: 0.18)
}
