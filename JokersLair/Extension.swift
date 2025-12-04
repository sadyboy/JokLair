import SwiftUI

// MARK: - Custom Colors
extension Color {
    // Joker Theme Colors
    static let jokerPurple = Color(red: 0.45, green: 0.1, blue: 0.55)
    static let jokerGreen = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let jokerRed = Color(red: 0.9, green: 0.1, blue: 0.2)
    static let jokerGold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let jokerDark = Color(red: 0.08, green: 0.05, blue: 0.12)
    static let jokerCard = Color(red: 0.95, green: 0.93, blue: 0.88)
    // Gradient Presets
    static let chaosGradient = LinearGradient(
        colors: [jokerPurple, jokerGreen.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let madnessGradient = LinearGradient(
        colors: [jokerPurple, jokerRed],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Custom View Modifiers
struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.8), radius: radius)
            .shadow(color: color.opacity(0.5), radius: radius * 1.5)
            .shadow(color: color.opacity(0.3), radius: radius * 2)
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct CardFlipModifier: ViewModifier {
    let isFlipped: Bool
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
    }
}

struct PulseAnimation: ViewModifier {
    @State private var isPulsing = false
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .foregroundColor(color)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                    .opacity(isPulsing ? 0 : 0.5)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isPulsing = true
                }
            }
    }
}

struct FloatingAnimation: ViewModifier {
    @State private var isFloating = false
    let duration: Double
    let distance: CGFloat
    
    init(duration: Double = 2.0, distance: CGFloat = 10) {
        self.duration = duration
        self.distance = distance
    }
    
    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -distance : distance)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isFloating = true
                }
            }
    }
}

struct RotatingAnimation: ViewModifier {
    @State private var rotation: Double = 0
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func glow(color: Color = .jokerGreen, radius: CGFloat = 10) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
    
    func shake(animatableData: CGFloat) -> some View {
        modifier(ShakeEffect(animatableData: animatableData))
    }
    
    func cardFlip(isFlipped: Bool) -> some View {
        modifier(CardFlipModifier(isFlipped: isFlipped))
    }
    
    func pulse(color: Color = .jokerGreen) -> some View {
        modifier(PulseAnimation(color: color))
    }
    
    func floating(duration: Double = 2.0, distance: CGFloat = 10) -> some View {
        modifier(FloatingAnimation(duration: duration, distance: distance))
    }
    
    func rotating(duration: Double = 10) -> some View {
        modifier(RotatingAnimation(duration: duration))
    }
    
    func jokerCard() -> some View {
        self
            .background(Color.jokerCard)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    func glassEffect() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Custom Shapes
struct WavyShape: Shape {
    var phase: Double
    
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2
        let wavelength = width / 2
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let y = midHeight + sin((relativeX + phase) * .pi * 2) * 20
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
