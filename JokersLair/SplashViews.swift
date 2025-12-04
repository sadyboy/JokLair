//
//  SplashViews.swift
//  JokersLair
//
//  Created by Serhii Anp on 04.12.2025.
//
import SwiftUI

struct SplashScreen: View {
    let isLoading: Bool
    @State private var currentImageIndex = 0
    @State private var fadeIn = false
    @State private var scaleEffect: CGFloat = 0.8
    @State private var rotationAngle: Double = 0
    @State private var timer: Timer?
    
    private let images = ["magic", "magicSecond", "magic", "magicSecond"]
    
    var body: some View {
        ZStack {
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
            
            ParticleEmitterView()
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                if !images.isEmpty && images.indices.contains(currentImageIndex) {
                    Image(images[currentImageIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .scaleEffect(scaleEffect)
                        .rotationEffect(.degrees(rotationAngle))
                        .opacity(fadeIn ? 1 : 0.3)
                        .shadow(color: .jokerPurple, radius: 20)
                        .animation(.easeInOut(duration: 1.5), value: fadeIn)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: scaleEffect)
                }
                
                // Loading indicator
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.jokerGreen)
                            .padding()
                        
                        Text("Preparing chaos...")
                            .font(.custom("AvenirNext-Bold", size: 18))
                            .foregroundColor(.white)
                            .opacity(0.8)
                    } else {
                        Text("Welcome to Jok Lair")
                            .font(.custom("AvenirNext-Bold", size: 24))
                            .foregroundColor(.white)
                            .shadow(color: .jokerPurple, radius: 10)
                    }
                    
                    // Animated dots while loading
                    if isLoading {
                        HStack(spacing: 10) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.jokerPurple)
                                    .frame(width: 10, height: 10)
                                    .opacity(0.7)
                                    .scaleEffect(
                                        scaleEffectForDot(index: index)
                                    )
                                    .animation(
                                        Animation.easeInOut(duration: 0.6)
                                            .repeatForever()
                                            .delay(Double(index) * 0.2),
                                        value: currentImageIndex
                                    )
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                
                Spacer()
                
                // Footer text
                Text("Do you want to know how I got these scars?")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.bottom, 30)
            }
            .padding()
        }
        .onAppear {
            startAnimations()
        }
        .onDisappear {
            stopAnimations()
        }
        .onChange(of: isLoading) { newValue in
            if newValue {
                startAnimations()
            } else {
                withAnimation(.easeOut(duration: 1.5)) {
                    scaleEffect = 1.2
                    fadeIn = true
                }
            }
        }
    }
    
    // MARK: - Animation Methods
    private func startAnimations() {
        // Start image rotation
        withAnimation(
            Animation.linear(duration: 20)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        // Start pulsating scale animation
        withAnimation(
            Animation.easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
        ) {
            scaleEffect = 1.1
        }
        
        // Start image carousel
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                fadeIn = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                currentImageIndex = (currentImageIndex + 1) % images.count
                withAnimation(.easeInOut(duration: 1)) {
                    fadeIn = true
                }
            }
        }
    }
    
    private func stopAnimations() {
        timer?.invalidate()
        timer = nil
    }
    
    private func scaleEffectForDot(index: Int) -> CGFloat {
        let baseTime = Date().timeIntervalSince1970
        let dotOffset = Double(index) * 0.2
        let time = baseTime + dotOffset
        let scale = 0.7 + 0.3 * sin(time * 3)
        return scale
    }
}

// MARK: - Particle Emitter for background
struct ParticleEmitterView: View {
    @State private var particles: [Particlese] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                
                for particle in particles {
                    let x = particle.x + cos(particle.angle) * particle.speed * now.truncatingRemainder(dividingBy: 10)
                    let y = particle.y + sin(particle.angle) * particle.speed * now.truncatingRemainder(dividingBy: 10)
                    
                    context.opacity = particle.opacity
                    context.fill(
                        Circle().path(in: CGRect(
                            x: x,
                            y: y,
                            width: particle.size,
                            height: particle.size
                        )),
                        with: .color(particle.color)
                    )
                }
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        particles = (0..<50).map { _ in
            Particlese(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                size: Double.random(in: 2...6),
                color: [Color.jokerPurple, Color.jokerGreen, Color.red, Color.yellow].randomElement()!,
                opacity: Double.random(in: 0.1...0.4),
                speed: Double.random(in: 0.1...0.5),
                angle: Double.random(in: 0...(2 * .pi))
            )
        }
    }
}

struct Particlese {
    var x: Double
    var y: Double
    var size: Double
    var color: Color
    var opacity: Double
    var speed: Double
    var angle: Double
}

// MARK: - Color Extensions


// MARK: - Preview
struct SplashScreen_Previews: View {
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            SplashScreen(isLoading: isLoading)
            
            Button("Toggle Loading") {
                isLoading.toggle()
            }
            .padding()
        }
    }
}
