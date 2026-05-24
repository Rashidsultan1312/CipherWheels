import SwiftUI

struct RootView: View {
    @AppStorage("cw.onboarding.seen") private var onboardingSeen = false

    var body: some View {
        DiscLaunchScaffold {
            if onboardingSeen {
                MainTabView()
            } else {
                OnboardingFlow()
            }
        }
    }
}
