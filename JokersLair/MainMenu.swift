import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var gameState: GameStateManager
    
    @State private var menuItemsAppeared: [Bool] = Array(repeating: false, count: 5)
    @State private var headerScale: CGFloat = 0.8
    @State private var headerOpacity: Double = 0
    @State private var chaosBarWidth: CGFloat = 0
    @State private var selectedItem: UUID?
    
    private let menuItems: [MenuItem] = [
        MenuItem(title: "Card Game", subtitle: "Test your luck against chaos", icon: "🎰", route: .cardGame,
                gradientColors: [.jokerPurple, .jokerGreen]),
        MenuItem(title: "Fortune Teller", subtitle: "Discover your chaotic destiny", icon: "🔮", route: .fortuneTeller,
                gradientColors: [.jokerPurple, .jokerRed]),
        MenuItem(title: "Chaos Tracker", subtitle: "Monitor your descent into madness", icon: "📊", route: .chaosMoodTracker,
                gradientColors: [.jokerGreen, .jokerGold]),
        MenuItem(title: "Joker's Wisdom", subtitle: "Quotes from the edge of sanity", icon: "💬", route: .jokerQuotes,
                gradientColors: [.jokerRed, .jokerPurple]),
        MenuItem(title: "Settings", subtitle: "Configure the madness", icon: "⚙️", route: .settings,
                gradientColors: [.gray, .jokerDark])
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                headerSection
                
                // Chaos level indicator
                chaosIndicator
                
                // Menu items
                menuGrid
                
                // Stats footer
                statsFooter
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(Color.clear)
        .navigationBarHidden(true)
        .onAppear {
            animateEntrance()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("🃏")
                    .font(.system(size: 40))
                    .floating(duration: 2, distance: 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("JOK LAIR")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.jokerGold, .jokerGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(gameState.currentMood.description)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Mood indicator
                moodBadge
            }
        }
        .padding()
        .glassEffect()
        .scaleEffect(headerScale)
        .opacity(headerOpacity)
    }
    
    private var moodBadge: some View {
        VStack(spacing: 4) {
            Text(gameState.currentMood.emoji)
                .font(.system(size: 30))
                .pulse(color: gameState.currentMood.color)
            
            Text(gameState.currentMood.rawValue)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(gameState.currentMood.color)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
    
    // MARK: - Chaos Indicator
    private var chaosIndicator: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CHAOS LEVEL")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("\(Int(gameState.chaosLevel * 100))%")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundColor(chaosLevelColor)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.1))
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.jokerGreen, chaosLevelColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: chaosBarWidth * geo.size.width)
                        .glow(color: chaosLevelColor, radius: 5)
                    
                    // Animated particles on bar
                    if gameState.chaosLevel > 0.5 {
                        chaosParticles(width: chaosBarWidth * geo.size.width)
                    }
                }
            }
            .frame(height: 12)
        }
        .padding()
        .glassEffect()
    }
    
    private var chaosLevelColor: Color {
        switch gameState.chaosLevel {
        case 0..<0.3: return .jokerGreen
        case 0.3..<0.6: return .jokerGold
        case 0.6..<0.8: return .orange
        default: return .jokerRed
        }
    }
    
    private func chaosParticles(width: CGFloat) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white)
                    .frame(width: 4, height: 4)
                    .offset(x: width - 20 + CGFloat(i * 6))
                    .opacity(Double.random(in: 0.3...0.8))
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.1),
                        value: gameState.chaosLevel
                    )
            }
        }
    }
    
    // MARK: - Menu Grid
    private var menuGrid: some View {
        VStack(spacing: 16) {
            ForEach(Array(menuItems.enumerated()), id: \.element.id) { index, item in
                MenuItemCard(
                    item: item,
                    isSelected: selectedItem == item.id,
                    isVisible: menuItemsAppeared[index]
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedItem = item.id
                    }
                    
                    // Haptic feedback simulation via visual
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        router.navigate(to: item.route)
                        selectedItem = nil
                    }
                }
            }
        }
    }
    
    // MARK: - Stats Footer
    private var statsFooter: some View {
        HStack(spacing: 20) {
            StatBadge(title: "Score", value: "\(gameState.playerScore)", icon: "⭐")
            StatBadge(title: "High Score", value: "\(gameState.highScore)", icon: "🏆")
            StatBadge(title: "Cards", value: "\(gameState.cardDeck.count)", icon: "🎴")
        }
        .padding()
        .glassEffect()
    }
    
    // MARK: - Animation
    private func animateEntrance() {
        // Header animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            headerScale = 1.0
            headerOpacity = 1.0
        }
        
        // Chaos bar animation
        withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
            chaosBarWidth = gameState.chaosLevel
        }
        
        // Menu items staggered animation
        for i in 0..<menuItems.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + Double(i) * 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    menuItemsAppeared[i] = true
                }
            }
        }
    }
}

// MARK: - Menu Item Card
struct MenuItemCard: View {
    let item: MenuItem
    let isSelected: Bool
    let isVisible: Bool
    let onTap: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: item.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Text(item.icon)
                        .font(.system(size: 28))
                }
                .glow(color: item.gradientColors.first ?? .jokerPurple, radius: isHovered ? 10 : 5)
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(item.subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .offset(x: isHovered ? 5 : 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: isHovered ? item.gradientColors : [.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isHovered ? 2 : 1
                            )
                    )
            )
            .scaleEffect(isSelected ? 0.95 : 1.0)
            .opacity(isVisible ? 1.0 : 0)
            .offset(x: isVisible ? 0 : -50)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = pressing
            }
        }, perform: {})
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.system(size: 20))
            
            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MainMenuView()
            .environmentObject(AppRouter())
            .environmentObject(GameStateManager())
    }
}
