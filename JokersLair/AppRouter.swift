import SwiftUI

// MARK: - App Routes
enum AppRoute: Hashable {
    case cardGame
    case fortuneTeller
    case chaosMoodTracker
    case jokerQuotes
    case settings
}

// MARK: - App Router (Navigation ViewModel)
@MainActor
class AppRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var selectedTab: Int = 0
    
    func navigate(to route: AppRoute) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            navigationPath.append(route)
        }
    }
    
    func goBack() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }
    }
    
    func goToRoot() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            navigationPath = NavigationPath()
        }
    }
}
