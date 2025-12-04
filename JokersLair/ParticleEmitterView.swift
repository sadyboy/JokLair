import SwiftUI

struct ParticleEmitterViews: View {
    @State private var particles: [Particles] = []
    
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    ParticleView(particle: particle)
                }
            }
            .onReceive(timer) { _ in
                addParticle(in: geo.size)
            }
            .onAppear {
                // Initial particles
                for _ in 0..<20 {
                    addParticle(in: geo.size, initial: true)
                }
            }
        }
    }
    
    private func addParticle(in size: CGSize, initial: Bool = false) {
        let particle = Particles(
            position: CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: initial ? CGFloat.random(in: 0...size.height) : size.height + 20
            ),
            color: [Color.jokerPurple, Color.jokerGreen, Color.jokerGold].randomElement()!,
            size: CGFloat.random(in: 2...6),
            opacity: Double.random(in: 0.2...0.5),
            speed: Double.random(in: 20...60)
        )
        
        particles.append(particle)
        
        // Remove old particles
        if particles.count > 50 {
            particles.removeFirst()
        }
    }
}

struct Particles: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    let opacity: Double
    let speed: Double
}

struct ParticleView: View {
    let particle: Particles
    
    @State private var offset: CGFloat = 0
    @State private var horizontalDrift: CGFloat = 0
    @State private var currentOpacity: Double = 0
    
    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .blur(radius: 1)
            .position(
                x: particle.position.x + horizontalDrift,
                y: particle.position.y - offset
            )
            .opacity(currentOpacity)
            .onAppear {
                withAnimation(.linear(duration: particle.speed / 10)) {
                    offset = 800
                    horizontalDrift = CGFloat.random(in: -100...100)
                }
                withAnimation(.easeIn(duration: 0.5)) {
                    currentOpacity = particle.opacity
                }
                withAnimation(.easeOut(duration: 0.5).delay(particle.speed / 10 - 0.5)) {
                    currentOpacity = 0
                }
            }
    }
}

// MARK: - Card Particle Effect
struct CardParticleEffect: View {
    let isActive: Bool
    let color: Color
    
    @State private var particles: [CardParticle] = []
    
    var body: some View {
        if #available(iOS 17.0, *) {
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                        .blur(radius: 1)
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    createBurst()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func createBurst() {
        particles = []
        
        for i in 0..<20 {
            let angle = Double(i) * (360.0 / 20.0) * .pi / 180.0
            let particle = CardParticle(
                position: CGPoint(x: 50, y: 75),
                size: CGFloat.random(in: 3...8),
                opacity: 1.0,
                angle: angle
            )
            particles.append(particle)
        }
        
        withAnimation(.easeOut(duration: 0.5)) {
            for i in particles.indices {
                let distance: CGFloat = 100
                particles[i].position = CGPoint(
                    x: 50 + cos(CGFloat(particles[i].angle)) * distance,
                    y: 75 + sin(CGFloat(particles[i].angle)) * distance
                )
                particles[i].opacity = 0
            }
        }
    }
}

struct CardParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    let angle: Double
}

// MARK: - Confetti Effect
struct ConfettiView: View {
    let isActive: Bool
    
    @State private var confetti: [ConfettiPiece] = []
    
    var body: some View {
        GeometryReader { geo in
            if #available(iOS 17.0, *) {
                ZStack {
                    ForEach(confetti) { piece in
                        ConfettiPieceView(piece: piece)
                    }
                }
                .onChange(of: isActive) { _, newValue in
                    if newValue {
                        createConfetti(in: geo.size)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func createConfetti(in size: CGSize) {
        confetti = []
        
        for _ in 0..<50 {
            let piece = ConfettiPiece(
                position: CGPoint(x: size.width / 2, y: 0),
                color: [.jokerPurple, .jokerGreen, .jokerGold, .jokerRed].randomElement()!,
                size: CGSize(
                    width: CGFloat.random(in: 5...15),
                    height: CGFloat.random(in: 10...20)
                ),
                rotation: Double.random(in: 0...360),
                targetX: CGFloat.random(in: 0...size.width),
                targetY: size.height + 50
            )
            confetti.append(piece)
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGSize
    var rotation: Double
    let targetX: CGFloat
    let targetY: CGFloat
}

struct ConfettiPieceView: View {
    let piece: ConfettiPiece
    
    @State private var currentPosition: CGPoint = .zero
    @State private var currentRotation: Double = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        Rectangle()
            .fill(piece.color)
            .frame(width: piece.size.width, height: piece.size.height)
            .position(currentPosition)
            .rotationEffect(.degrees(currentRotation))
            .opacity(opacity)
            .onAppear {
                currentPosition = piece.position
                currentRotation = piece.rotation
                
                withAnimation(.easeOut(duration: Double.random(in: 2...4))) {
                    currentPosition = CGPoint(x: piece.targetX, y: piece.targetY)
                    currentRotation = piece.rotation + Double.random(in: 360...720)
                    opacity = 0
                }
            }
    }
}
