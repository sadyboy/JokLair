import SwiftUI

struct FortuneTellerView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var gameState: GameStateManager
    @StateObject private var viewModel = FortuneTellerViewModel()
    
    @State private var orbRotation: Double = 0
    @State private var orbGlow: CGFloat = 10
    @State private var isRevealing = false
    @State private var smokeOpacity: Double = 0
    @State private var cardsRevealed: [Bool] = [false, false, false]
    
    var body: some View {
        ZStack {
            // Mystical background
            mysticalBackground
            
            VStack(spacing: 30) {
                // Header
                header
                
                Spacer()
                
                // Crystal orb
                crystalOrb
                
                // Fortune cards or revealed fortune
                if viewModel.revealedFortune != nil {
                    revealedFortuneView
                } else {
                    fortuneCards
                }
                
                Spacer()
                
                // Action button
                actionButton
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .onAppear {
            startAmbientAnimations()
        }
    }
    
    // MARK: - Components
    
    private var mysticalBackground: some View {
        ZStack {
            // Base gradient
            RadialGradient(
                colors: [
                    Color.jokerPurple.opacity(0.6),
                    Color.black,
                    Color.jokerDark
                ],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // Mystical smoke effect
            ForEach(0..<5, id: \.self) { i in
                SmokeCloud(index: i)
                    .opacity(smokeOpacity)
            }
            
            // Stars
            StarsView()
                .opacity(0.6)
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("🔮 THE ORACLE 🔮")
                .font(.system(size: 28, weight: .black, design: .serif))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.jokerPurple, .jokerGold, .jokerPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .glow(color: .jokerPurple, radius: 10)
            
            Text("Peer into the chaos and discover your fate")
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundColor(.white.opacity(0.6))
                .italic()
        }
    }
    
    private var crystalOrb: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.jokerPurple.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 60,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .blur(radius: orbGlow)
            
            // Orb base
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.jokerPurple.opacity(0.5),
                            Color.jokerDark.opacity(0.8)
                        ],
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 100
                    )
                )
                .frame(width: 150, height: 150)
                .overlay(
                    // Inner swirl
                    OrbSwirl()
                        .rotationEffect(.degrees(orbRotation))
                        .mask(Circle())
                )
                .overlay(
                    // Highlight
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: 60, height: 60)
                        .offset(x: -30, y: -30)
                )
                .shadow(color: .jokerPurple.opacity(0.5), radius: 30)
            
            // Floating symbols
            ForEach(0..<4, id: \.self) { i in
                Text(["♠️", "♥️", "♦️", "♣️"][i])
                    .font(.system(size: 20))
                    .offset(orbSymbolOffset(for: i))
                    .opacity(isRevealing ? 1.0 : 0.3)
            }
        }
        .scaleEffect(isRevealing ? 1.1 : 1.0)
    }
    
    private var fortuneCards: some View {
        HStack(spacing: 20) {
            ForEach(0..<3, id: \.self) { index in
                FortuneCardView(
                    index: index,
                    isRevealed: cardsRevealed[index]
                )
                .onTapGesture {
                    selectCard(at: index)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var revealedFortuneView: some View {
        VStack(spacing: 20) {
            if let fortune = viewModel.revealedFortune {
                // Category badge
                Text(fortune.category.rawValue.uppercased())
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.jokerGold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.jokerGold.opacity(0.2))
                    .cornerRadius(12)
                
                // Fortune text
                Text("\"\(fortune.text)\"")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .italic()
                
                // Chaos rating
                HStack(spacing: 4) {
                    Text("Chaos Rating:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    ForEach(0..<5, id: \.self) { i in
                        Text("🃏")
                            .font(.system(size: 16))
                            .opacity(i < fortune.chaosRating ? 1.0 : 0.3)
                    }
                }
            }
        }
        .padding()
        .glassEffect()
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .opacity
        ))
    }
    
    private var actionButton: some View {
        Button(action: {
            if viewModel.revealedFortune != nil {
                resetFortune()
            } else {
                revealFortune()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: viewModel.revealedFortune != nil ? "arrow.clockwise" : "sparkles")
                    .font(.system(size: 18, weight: .bold))
                
                Text(viewModel.revealedFortune != nil ? "SEEK ANOTHER FORTUNE" : "CONSULT THE ORACLE")
                    .font(.system(size: 16, weight: .bold, design: .serif))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.jokerPurple, .jokerPurple.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(30)
            .shadow(color: .jokerPurple.opacity(0.5), radius: 10)
        }
        .disabled(isRevealing)
        .opacity(isRevealing ? 0.5 : 1.0)
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
    
    // MARK: - Helper Methods
    
    private func orbSymbolOffset(for index: Int) -> CGSize {
        let radius: CGFloat = 100
        let angle = CGFloat((Double(index) * 90 + orbRotation) * .pi / 180)
        return CGSize(
            width: cos(angle) * radius,
            height: sin(angle) * radius
        )
    }
    
    private func startAmbientAnimations() {
        // Orb rotation
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            orbRotation = 360
        }
        
        // Glow pulsing
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            orbGlow = 20
        }
        
        // Smoke
        withAnimation(.easeIn(duration: 2)) {
            smokeOpacity = 0.4
        }
    }
    
    private func selectCard(at index: Int) {
        guard !isRevealing && viewModel.revealedFortune == nil else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            cardsRevealed[index] = true
        }
        
        isRevealing = true
        
        // Reveal animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                viewModel.revealFortune()
            }
            
            // Update chaos level
            if let fortune = viewModel.revealedFortune {
                let chaosChange = Double(fortune.chaosRating) * 0.02
                gameState.updateChaosLevel(chaosChange)
            }
            
            isRevealing = false
        }
    }
    
    private func revealFortune() {
        // Trigger card selection animation for center card
        selectCard(at: 1)
    }
    
    private func resetFortune() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.reset()
            cardsRevealed = [false, false, false]
        }
    }
}

// MARK: - Fortune Card View
struct FortuneCardView: View {
    let index: Int
    let isRevealed: Bool
    
    @State private var hover = false
    
    private let symbols = ["🌙", "⭐", "🔥"]
    
    var body: some View {
        ZStack {
            // Card back / front
            if isRevealed {
                cardFront
            } else {
                cardBack
            }
        }
        .frame(width: 80, height: 120)
        .rotation3DEffect(
            .degrees(isRevealed ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .scaleEffect(hover ? 1.05 : 1.0)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                hover = pressing
            }
        }, perform: {})
    }
    
    private var cardBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [.jokerPurple, .jokerDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Mystical pattern
            VStack(spacing: 8) {
                Text("?")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundColor(.jokerGold.opacity(0.7))
            }
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.jokerGold.opacity(0.5), lineWidth: 2)
        }
        .shadow(color: .jokerPurple.opacity(0.3), radius: 10)
    }
    
    private var cardFront: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [.jokerGold.opacity(0.3), .jokerPurple.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text(symbols[index])
                .font(.system(size: 40))
                .rotationEffect(.degrees(180))
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.jokerGold, lineWidth: 2)
        }
        .shadow(color: .jokerGold.opacity(0.5), radius: 15)
    }
}

// MARK: - Orb Swirl
struct OrbSwirl: View {
    @State private var phase: Double = 0
    
    var body: some View {
        Canvas { context, size in
            for i in 0..<3 {
                let opacity = 0.3 - Double(i) * 0.1
                let offset = Double(i) * 30
                
                var path = Path()
                path.addArc(
                    center: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: 30 + CGFloat(i * 10),
                    startAngle: .degrees(phase + offset),
                    endAngle: .degrees(phase + 180 + offset),
                    clockwise: false
                )
                
                context.stroke(
                    path,
                    with: .color(.jokerGold.opacity(opacity)),
                    lineWidth: 2
                )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                phase = 360
            }
        }
    }
}

// MARK: - Smoke Cloud
struct SmokeCloud: View {
    let index: Int
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(Color.jokerPurple.opacity(0.2))
            .frame(width: 200, height: 200)
            .blur(radius: 50)
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                let baseOffset = CGSize(
                    width: CGFloat.random(in: -100...100),
                    height: CGFloat.random(in: -200...200)
                )
                offset = baseOffset
                
                withAnimation(.easeInOut(duration: Double.random(in: 4...8)).repeatForever(autoreverses: true)) {
                    offset = CGSize(
                        width: baseOffset.width + CGFloat.random(in: -50...50),
                        height: baseOffset.height + CGFloat.random(in: -50...50)
                    )
                    opacity = Double.random(in: 0.2...0.5)
                }
            }
    }
}

// MARK: - Stars View
struct StarsView: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<30, id: \.self) { i in
                StarView()
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: CGFloat.random(in: 0...geo.size.height)
                    )
            }
        }
    }
}

struct StarView: View {
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: CGFloat.random(in: 1...3))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: Double.random(in: 1...3)).repeatForever(autoreverses: true)) {
                    opacity = Double.random(in: 0.5...1.0)
                }
            }
    }
}

#Preview {
    NavigationStack {
        FortuneTellerView()
            .environmentObject(AppRouter())
            .environmentObject(GameStateManager())
    }
}
