import SwiftUI

enum AppScreen {
    case welcome
    case onboarding
    case dashboard
    case medications
    case calendar
    case vitals
    case carersPack
}

@Observable
class AppState {
    var screen: AppScreen = .welcome
    var petName: String = "Angel"
}
