import SwiftUI

struct AtelierCanvas: View {
    var opacity: Double = 0.55
    var imageName: String = AtelierBackdrop.primary

    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.97, blue: 0.93)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(opacity)
                .ignoresSafeArea()
            LinearGradient(colors: [Color.white.opacity(0.74), Color.white.opacity(0.82)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            LinearGradient(colors: [Palette.bordeaux.opacity(0.04), Color.clear],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct AtelierScrim: View {
    let kind: CipherKind

    var body: some View {
        AtelierAccent.tint(for: kind)
            .opacity(0.08)
            .ignoresSafeArea()
    }
}
