import SwiftUI

struct ContentView: View {
    @State private var state = AppState()

    var body: some View {
        ZStack {
            Halo.bg.ignoresSafeArea()
            switch state.screen {
            case .welcome:
                WelcomeView()
            case .onboarding:
                OnboardingView()
            case .dashboard, .medications, .calendar, .vitals, .carersPack:
                MainTabView()
            }
        }
        .environment(state)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
