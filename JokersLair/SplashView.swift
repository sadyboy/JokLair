import SwiftUI

struct SplashViews: View {
    let onComplete: () -> Void
    
    @State private var jokerScale: CGFloat = 0.3
    @State private var jokerRotation: Double = -30
    @State private var jokerOpacity: Double = 0
    @State private var titleOffset: CGFloat = 50
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var glowRadius: CGFloat = 0
    @State private var cardsAppeared: [Bool] = Array(repeating: false, count: 5)
    @State private var showLightning: Bool = false
    @State private var backgroundPulse: Bool = false
    
    var body: some View {
        ZStack {
            // Animated background
            animatedBackground
            
            // Lightning effect
            if showLightning {
                lightningEffect
            }
            
            // Floating cards in background
            floatingCardsBackground
            
            // Main content
            VStack(spacing: 30) {
                Spacer()
                
                // Joker emoji with dramatic entrance
                jokerEmoji
                
                // Title with glitch effect
                titleView
                
                // Subtitle
                subtitleView
                
                Spacer()
                
                // Loading indicator
                loadingIndicator
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    // MARK: - Components
    
    private var animatedBackground: some View {
        ZStack {
            // Base gradient
            RadialGradient(
                colors: [
                    Color.jokerPurple.opacity(backgroundPulse ? 0.8 : 0.5),
                    Color.black,
                    Color.jokerGreen.opacity(backgroundPulse ? 0.3 : 0.1)
                ],
                center: .center,
                startRadius: backgroundPulse ? 100 : 50,
                endRadius: backgroundPulse ? 500 : 400
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: backgroundPulse)
            
            // Rotating geometric pattern
            GeometricPatternView()
                .opacity(0.15)
        }
    }
    
    private var lightningEffect: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                LightningBolt()
                    .stroke(Color.jokerGold, lineWidth: 2)
                    .frame(width: 100, height: 200)
                    .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -300...0))
                    .opacity(Double.random(in: 0.3...0.8))
            }
        }
        .transition(.opacity)
    }
    
    private var floatingCardsBackground: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                FloatingCardView(index: index, isVisible: cardsAppeared[index])
            }
        }
    }
    
    private var jokerEmoji: some View {
        ZStack {
            // Glow effect
            Text("🃏")
                .font(.system(size: 150))
                .blur(radius: glowRadius)
                .opacity(0.5)
            
            // Main emoji
            Text("🃏")
                .font(.system(size: 120))
                .scaleEffect(jokerScale)
                .rotationEffect(.degrees(jokerRotation))
                .opacity(jokerOpacity)
                .shadow(color: .jokerPurple.opacity(0.8), radius: 20)
                .shadow(color: .jokerGreen.opacity(0.5), radius: 40)
        }
    }
    
    private var titleView: some View {
        ZStack {
            // Glitch layers
            Text("JOK LAIR")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(.jokerRed.opacity(0.8))
                .offset(x: -2, y: -2)
                .opacity(titleOpacity * 0.5)
            
            Text("JOK LAIR")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(.jokerGreen.opacity(0.8))
                .offset(x: 2, y: 2)
                .opacity(titleOpacity * 0.5)
            
            // Main title
            Text("JOK LAIR")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.jokerGold, .jokerGreen, .jokerPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(titleOpacity)
                .offset(y: titleOffset)
        }
        .glow(color: .jokerGreen, radius: 15)
    }
    
    private var subtitleView: some View {
        Text("Where Chaos Meets Fortune")
            .font(.system(size: 16, weight: .medium, design: .monospaced))
            .foregroundColor(.white.opacity(0.7))
            .opacity(subtitleOpacity)
            .tracking(3)
    }
    
    private var loadingIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(Color.jokerGreen)
                    .frame(width: 8, height: 8)
                    .scaleEffect(cardsAppeared[index] ? 1.0 : 0.5)
                    .opacity(cardsAppeared[index] ? 1.0 : 0.3)
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: cardsAppeared[index]
                    )
            }
        }
        .opacity(subtitleOpacity)
    }
    
    // MARK: - Animation Sequence
    
    private func startAnimationSequence() {
        // Start background pulse
        backgroundPulse = true
        
        // Joker entrance
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            jokerScale = 1.0
            jokerRotation = 0
            jokerOpacity = 1.0
        }
        
        // Glow effect
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowRadius = 30
        }
        
        // Title animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
        }
        
        // Subtitle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeIn(duration: 0.5)) {
                subtitleOpacity = 1.0
            }
        }
        
        // Lightning flash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.2)) {
                showLightning = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeIn(duration: 0.1)) {
                    showLightning = false
                }
            }
        }
        
        // Floating cards
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + Double(i) * 0.15) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    cardsAppeared[i] = true
                }
            }
        }
        
        // Complete splash
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            onComplete()
        }
    }
}

// MARK: - Supporting Views

struct FloatingCardView: View {
    let index: Int
    let isVisible: Bool
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    
    private let cardSymbols = ["♠️", "♥️", "♦️", "♣️", "🃏"]
    
    var body: some View {
        Text(cardSymbols[index])
            .font(.system(size: 50))
            .opacity(isVisible ? 0.3 : 0)
            .scaleEffect(isVisible ? 1.0 : 0.5)
            .offset(x: positions[index].x + offset.width,
                    y: positions[index].y + offset.height)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.easeInOut(duration: Double.random(in: 3...5)).repeatForever(autoreverses: true)) {
                    offset = CGSize(width: CGFloat.random(in: -30...30),
                                   height: CGFloat.random(in: -30...30))
                    rotation = Double.random(in: -20...20)
                }
            }
    }
    
    private var positions: [CGPoint] {
        [
            CGPoint(x: -120, y: -250),
            CGPoint(x: 130, y: -200),
            CGPoint(x: -100, y: 200),
            CGPoint(x: 110, y: 250),
            CGPoint(x: 0, y: 300)
        ]
    }
}

struct GeometricPatternView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                DiamondShape()
                    .stroke(Color.jokerPurple.opacity(0.3), lineWidth: 1)
                    .frame(width: 200 + CGFloat(i * 50), height: 200 + CGFloat(i * 50))
                    .rotationEffect(.degrees(rotation + Double(i * 15)))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

struct LightningBolt: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points: [CGPoint] = [
            CGPoint(x: rect.midX, y: rect.minY),
            CGPoint(x: rect.midX - 20, y: rect.height * 0.4),
            CGPoint(x: rect.midX + 10, y: rect.height * 0.4),
            CGPoint(x: rect.midX - 30, y: rect.maxY),
            CGPoint(x: rect.midX + 5, y: rect.height * 0.55),
            CGPoint(x: rect.midX - 15, y: rect.height * 0.55),
            CGPoint(x: rect.midX, y: rect.minY)
        ]
        
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        return path
    }
}
