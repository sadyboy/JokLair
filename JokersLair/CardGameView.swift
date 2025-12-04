import SwiftUI
import SpriteKit

struct CardGameView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var gameState: GameStateManager
    @StateObject private var viewModel = CardGameViewModel()
    
    @State private var showResult = false
    @State private var resultMessage = ""
    @State private var isWin = false
    
    var body: some View {
        ZStack {
            // SpriteKit background
            SpriteView(scene: viewModel.gameScene)
                .ignoresSafeArea()
            
            // Game UI overlay
            VStack {
                // Header
                gameHeader
                
                Spacer()
                
                // Card display area
                cardDisplayArea
                
                Spacer()
                
                // Control buttons
                controlButtons
                
                // Bottom stats
                bottomStats
            }
            .padding()
            
            // Result overlay
            if showResult {
                resultOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .onAppear {
            viewModel.setup(with: gameState)
        }
    }
    
    // MARK: - Components
    
    private var gameHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("CHAOS CARDS")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.jokerGold, .jokerGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Higher or Lower? The Joker decides...")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Score display
            VStack(alignment: .trailing, spacing: 2) {
                Text("SCORE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                
                Text("\(viewModel.currentScore)")
                    .font(.system(size: 28, weight: .black, design: .monospaced))
                    .foregroundColor(.jokerGold)
                    .glow(color: .jokerGold, radius: 5)
            }
        }
        .padding()
        .glassEffect()
    }
    
    private var cardDisplayArea: some View {
        HStack(spacing: 30) {
            // Current card
            if let card = viewModel.currentCard {
                CardView(card: card, isFlipped: false)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                PlaceholderCardView(text: "Draw a card")
            }
            
            // VS indicator
            Text("VS")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.jokerRed)
                .glow(color: .jokerRed, radius: 10)
                .floating(duration: 1.5, distance: 5)
            
            // Next card
            if let nextCard = viewModel.nextCard {
                CardView(card: nextCard, isFlipped: !viewModel.isNextCardRevealed)
                    .transition(.scale.combined(with: .opacity))
            } else {
                PlaceholderCardView(text: "???")
            }
        }
        .frame(height: 200)
    }
    
    private var controlButtons: some View {
        VStack(spacing: 16) {
            if viewModel.gamePhase == .guessing {
                HStack(spacing: 20) {
                    GameButton(
                        title: "HIGHER",
                        icon: "arrow.up.circle.fill",
                        colors: [.jokerGreen, .jokerGreen.opacity(0.7)]
                    ) {
                        makeGuess(higher: true)
                    }
                    
                    GameButton(
                        title: "LOWER",
                        icon: "arrow.down.circle.fill",
                        colors: [.jokerRed, .jokerRed.opacity(0.7)]
                    ) {
                        makeGuess(higher: false)
                    }
                }
                
                // Wild card button
                if viewModel.wildCardsRemaining > 0 {
                    Button(action: useWildCard) {
                        HStack {
                            Text("🃏")
                                .font(.system(size: 20))
                            Text("USE WILD CARD (\(viewModel.wildCardsRemaining))")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.jokerGold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.jokerPurple.opacity(0.5))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.jokerGold, lineWidth: 1)
                        )
                    }
                    .pulse(color: .jokerGold)
                }
            } else if viewModel.gamePhase == .waiting {
                GameButton(
                    title: "DRAW CARD",
                    icon: "rectangle.stack.fill",
                    colors: [.jokerPurple, .jokerGreen]
                ) {
                    drawNewCard()
                }
            } else if viewModel.gamePhase == .gameOver {
                VStack(spacing: 12) {
                    Text("GAME OVER")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.jokerRed)
                        .glow(color: .jokerRed, radius: 10)
                    
                    Text("Final Score: \(viewModel.currentScore)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    GameButton(
                        title: "PLAY AGAIN",
                        icon: "arrow.clockwise",
                        colors: [.jokerGreen, .jokerPurple]
                    ) {
                        viewModel.resetGame()
                    }
                }
            }
        }
    }
    
    private var bottomStats: some View {
        HStack(spacing: 30) {
            StatPill(title: "Streak", value: "\(viewModel.currentStreak)", icon: "🔥")
            StatPill(title: "Cards Left", value: "\(viewModel.cardsRemaining)", icon: "🎴")
            StatPill(title: "Best", value: "\(viewModel.bestStreak)", icon: "⭐")
        }
        .padding()
        .glassEffect()
    }
    
    private var backButton: some View {
        Button(action: { router.goBack() }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                Text("Back")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var resultOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(isWin ? "🎉" : "💀")
                    .font(.system(size: 80))
                    .scaleEffect(showResult ? 1.0 : 0.5)
                
                Text(resultMessage)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isWin ? .jokerGreen : .jokerRed)
                    .multilineTextAlignment(.center)
                
                if isWin {
                    Text("+\(viewModel.lastPointsEarned) points!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.jokerGold)
                }
            }
            .padding(40)
            .glassEffect()
            .scaleEffect(showResult ? 1.0 : 0.8)
        }
        .transition(.opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showResult = false
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func makeGuess(higher: Bool) {
        let result = viewModel.makeGuess(higher: higher)
        isWin = result.won
        resultMessage = result.message
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            showResult = true
        }
        
        // Update chaos level based on result
        gameState.updateChaosLevel(result.won ? 0.05 : -0.03)
        
        if result.won {
            gameState.updateScore(by: viewModel.lastPointsEarned)
        }
    }
    
    private func drawNewCard() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.drawCards()
        }
    }
    
    private func useWildCard() {
        viewModel.useWildCard()
    }
}

// MARK: - Card View
struct CardView: View {
    let card: PlayingCard
    let isFlipped: Bool
    
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            if isFlipped {
                // Card back
                cardBack
            } else {
                // Card front
                cardFront
            }
        }
        .frame(width: 100, height: 150)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isFlipped)
    }
    
    private var cardFront: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.jokerCard)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(card.isJoker ? Color.jokerPurple : Color.gray.opacity(0.3), lineWidth: 2)
            
            VStack {
                if card.isJoker {
                    Text("🃏")
                        .font(.system(size: 50))
                    Text("JOKER")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.jokerPurple)
                } else {
                    Text(card.rank.rawValue)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(card.suit.color == .white ? .black : card.suit.color)
                    
                    Text(card.suit.rawValue)
                        .font(.system(size: 30))
                }
            }
        }
        .shadow(color: card.isJoker ? .jokerPurple.opacity(0.5) : .black.opacity(0.2), radius: 10)
    }
    
    private var cardBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.jokerPurple, .jokerDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Pattern
            GeometryReader { geo in
                Path { path in
                    let size: CGFloat = 20
                    for row in 0..<Int(geo.size.height / size) {
                        for col in 0..<Int(geo.size.width / size) {
                            let x = CGFloat(col) * size
                            let y = CGFloat(row) * size
                            if (row + col) % 2 == 0 {
                                path.addRect(CGRect(x: x, y: y, width: size, height: size))
                            }
                        }
                    }
                }
                .fill(Color.jokerGreen.opacity(0.2))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Center logo
            Text("🃏")
                .font(.system(size: 40))
                .rotationEffect(.degrees(180))
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.jokerGold.opacity(0.5), lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

// MARK: - Placeholder Card
struct PlaceholderCardView: View {
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .frame(width: 100, height: 150)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [10]))
                .frame(width: 100, height: 150)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

// MARK: - Game Button
struct GameButton: View {
    let title: String
    let icon: String
    let colors: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                Text(title)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(25)
            .shadow(color: colors.first?.opacity(0.5) ?? .clear, radius: isPressed ? 5 : 10)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
    }
}

// MARK: - Stat Pill
struct StatPill: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.system(size: 16))
            Text(value)
                .font(.system(size: 18, weight: .black, design: .monospaced))
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

#Preview {
    NavigationStack {
        CardGameView()
            .environmentObject(AppRouter())
            .environmentObject(GameStateManager())
    }
}
