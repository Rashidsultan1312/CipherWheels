import SwiftUI

struct DiscLaunchScaffold<Plate: View>: View {
    @AppStorage("cw.disc.ringed") private var ringed = false
    @State private var spoke: Spoke = .calibrating
    @State private var consentOpen = false
    @ViewBuilder var plate: () -> Plate

    var body: some View {
        Group {
            if ringed {
                plate()
            } else {
                switch spoke {
                case .calibrating:
                    ZStack {
                        Color(.systemGroupedBackground).ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(1.25)
                    }
                    .task { await revolve() }
                case .revolved(let url):
                    DiscFrame(circle: url, sterile: false)
                        .ignoresSafeArea()
                case .consent:
                    Color(.systemGroupedBackground).ignoresSafeArea()
                        .fullScreenCover(isPresented: $consentOpen) {
                            DiscConsentPanel(scroll: AppConfig.privacyPolicyURL) {
                                ringed = true
                                consentOpen = false
                                spoke = .untied
                            }
                        }
                case .untied:
                    plate()
                }
            }
        }
    }

    @MainActor
    private func revolve() async {
        async let breather: Void = { try? await Task.sleep(nanoseconds: 1_300_000_000) }()
        async let turn = DiscLedger.spin()
        let outcome = await turn
        _ = await breather
        switch outcome {
        case .revolved(let url):
            spoke = .revolved(url)
        case .locked:
            spoke = .consent
            Task { @MainActor in consentOpen = true }
        case .mute:
            spoke = .untied
        }
    }

    private enum Spoke: Equatable {
        case calibrating
        case revolved(URL)
        case consent
        case untied
    }
}
