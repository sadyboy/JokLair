import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var router: AppRouter
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            // Background gradient - Joker's chaotic purple-green theme
            LinearGradient(
                colors: [
                    Color.jokerPurple.opacity(0.9),
                    Color.black,
                    Color.jokerGreen.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background particles
            ParticleEmitterViews()
                .ignoresSafeArea()
                .opacity(0.6)
            
            if showSplash {
                SplashViews(onComplete: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showSplash = false
                    }
                })
                .transition(.asymmetric(
                    insertion: .opacity,
                    removal: .scale(scale: 1.5).combined(with: .opacity)
                ))
            } else {
                NavigationStack(path: $router.navigationPath) {
                    MainMenuView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .cardGame:
                                CardGameView()
                            case .fortuneTeller:
                                FortuneTellerView()
                            case .chaosMoodTracker:
                                ChaosMoodTrackerView()
                            case .jokerQuotes:
                                JokerQuotesView()
                            case .settings:
                                SettingsView()
                            }
                        }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}
