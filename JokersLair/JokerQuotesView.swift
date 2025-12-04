import SwiftUI

struct JokerQuotesView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = QuotesViewModel()
    
    @State private var currentQuoteIndex = 0
    @State private var quoteOpacity: Double = 0
    @State private var quoteOffset: CGFloat = 50
    @State private var isAutoPlaying = true
    @State private var glitchEffect = false
    
    var body: some View {
        ZStack {
            // Background
            dramaticBackground
            
            VStack(spacing: 0) {
                // Header
                header
                
                Spacer()
                
                // Quote display
                quoteDisplay
                
                Spacer()
                
                // Controls
                controls
                
                // Quote navigation dots
                navigationDots
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                autoPlayToggle
            }
        }
        .onAppear {
            showQuote()
            if isAutoPlaying {
                startAutoPlay()
            }
        }
    }
    
    // MARK: - Components
    
    private var dramaticBackground: some View {
        ZStack {
            // Base
            Color.black.ignoresSafeArea()
            
            // Animated gradient
            RadialGradient(
                colors: [
                    Color.jokerPurple.opacity(0.4),
                    Color.black,
                    Color.jokerGreen.opacity(0.1)
                ],
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            // Glitch lines
            if glitchEffect {
                GlitchLinesView()
                    .transition(.opacity)
            }
            
            // Floating joker symbols
            FloatingSymbolsView()
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("💬 JOK WISDOM 💬")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.jokerGold, .jokerRed],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .glow(color: .jokerGold, radius: 5)
            
            Text("Words from the edge of sanity")
                .font(.system(size: 12, weight: .medium, design: .serif))
                .foregroundColor(.white.opacity(0.5))
                .italic()
        }
        .padding(.top)
    }
    
    private var quoteDisplay: some View {
        VStack(spacing: 30) {
            // Opening quote mark
            Text("❝")
                .font(.system(size: 60))
                .foregroundColor(.jokerPurple.opacity(0.5))
            
            // Quote text
            Text(viewModel.quotes[currentQuoteIndex].text)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 20)
                .opacity(quoteOpacity)
                .offset(y: quoteOffset)
            
            // Closing quote mark
            Text("❞")
                .font(.system(size: 60))
                .foregroundColor(.jokerPurple.opacity(0.5))
            
            // Attribution
            HStack {
                Rectangle()
                    .fill(Color.jokerGold)
                    .frame(width: 30, height: 2)
                
                Text(viewModel.quotes[currentQuoteIndex].source)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.jokerGold)
                
                Rectangle()
                    .fill(Color.jokerGold)
                    .frame(width: 30, height: 2)
            }
            .opacity(quoteOpacity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .glassEffect()
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        nextQuote()
                    } else if value.translation.width > 50 {
                        previousQuote()
                    }
                }
        )
    }
    
    private var controls: some View {
        HStack(spacing: 30) {
            // Previous
            ControlButton(icon: "chevron.left.circle.fill", size: 40) {
                previousQuote()
            }
            
            // Shuffle
            ControlButton(icon: "shuffle.circle.fill", size: 50, color: .jokerPurple) {
                shuffleQuote()
            }
            
            // Next
            ControlButton(icon: "chevron.right.circle.fill", size: 40) {
                nextQuote()
            }
        }
        .padding(.vertical, 20)
    }
    
    private var navigationDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<min(viewModel.quotes.count, 10), id: \.self) { index in
                Circle()
                    .fill(index == currentQuoteIndex % 10 ? Color.jokerGold : Color.white.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentQuoteIndex % 10 ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentQuoteIndex)
            }
        }
        .padding(.bottom)
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
    
    private var autoPlayToggle: some View {
        Button(action: {
            isAutoPlaying.toggle()
            if isAutoPlaying {
                startAutoPlay()
            }
        }) {
            Image(systemName: isAutoPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(isAutoPlaying ? .jokerGreen : .white.opacity(0.5))
        }
    }
    
    // MARK: - Actions
    
    private func showQuote() {
        // Reset
        quoteOpacity = 0
        quoteOffset = 50
        
        // Animate in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            quoteOpacity = 1
            quoteOffset = 0
        }
    }
    
    private func nextQuote() {
        triggerGlitch()
        
        withAnimation(.easeOut(duration: 0.2)) {
            quoteOpacity = 0
            quoteOffset = -50
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            currentQuoteIndex = (currentQuoteIndex + 1) % viewModel.quotes.count
            quoteOffset = 50
            showQuote()
        }
    }
    
    private func previousQuote() {
        triggerGlitch()
        
        withAnimation(.easeOut(duration: 0.2)) {
            quoteOpacity = 0
            quoteOffset = 50
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            currentQuoteIndex = currentQuoteIndex > 0 ? currentQuoteIndex - 1 : viewModel.quotes.count - 1
            quoteOffset = -50
            showQuote()
        }
    }
    
    private func shuffleQuote() {
        triggerGlitch()
        
        withAnimation(.easeOut(duration: 0.2)) {
            quoteOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            currentQuoteIndex = Int.random(in: 0..<viewModel.quotes.count)
            showQuote()
        }
    }
    
    private func triggerGlitch() {
        withAnimation(.easeInOut(duration: 0.1)) {
            glitchEffect = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                glitchEffect = false
            }
        }
    }
    
    private func startAutoPlay() {
        guard isAutoPlaying else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [self] in
            if isAutoPlaying {
                nextQuote()
                startAutoPlay()
            }
        }
    }
}

// MARK: - Control Button
struct ControlButton: View {
    let icon: String
    let size: CGFloat
    var color: Color = .white.opacity(0.7)
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundColor(color)
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
    }
}

// MARK: - Glitch Lines View
struct GlitchLinesView: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<5, id: \.self) { i in
                Rectangle()
                    .fill(Color.jokerGreen.opacity(Double.random(in: 0.1...0.3)))
                    .frame(height: CGFloat.random(in: 2...10))
                    .offset(y: CGFloat.random(in: 0...geo.size.height))
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Floating Symbols View
struct FloatingSymbolsView: View {
    @State private var symbols: [(String, CGPoint, Double)] = []
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<10, id: \.self) { i in
                FloatingSymbol(
                    symbol: ["🃏", "♠️", "♥️", "♦️", "♣️"].randomElement()!,
                    index: i
                )
            }
        }
        .opacity(0.15)
    }
}

struct FloatingSymbol: View {
    let symbol: String
    let index: Int
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Text(symbol)
            .font(.system(size: CGFloat.random(in: 20...40)))
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                offset = CGSize(
                    width: CGFloat.random(in: -150...150),
                    height: CGFloat.random(in: -300...300)
                )
                
                withAnimation(
                    .easeInOut(duration: Double.random(in: 5...10))
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: CGFloat.random(in: -150...150),
                        height: CGFloat.random(in: -300...300)
                    )
                    rotation = Double.random(in: -180...180)
                    opacity = Double.random(in: 0.1...0.4)
                }
            }
    }
}

#Preview {
    NavigationStack {
        JokerQuotesView()
            .environmentObject(AppRouter())
    }
}
