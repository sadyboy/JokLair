import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var gameState: GameStateManager
    
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("soundEffects") private var soundEffects = true
    @AppStorage("notifications") private var notifications = false
    @AppStorage("darkMode") private var darkMode = true
    
    @State private var showResetConfirmation = false
    @State private var animateGear = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.jokerDark, Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    header
                    
                    // General settings
                    settingsSection(title: "GENERAL", items: [
                        SettingsToggle(title: "Haptic Feedback", icon: "waveform", isOn: $hapticFeedback),
                        SettingsToggle(title: "Sound Effects", icon: "speaker.wave.2", isOn: $soundEffects),
                        SettingsToggle(title: "Notifications", icon: "bell", isOn: $notifications),
                        SettingsToggle(title: "Dark Mode", icon: "moon.fill", isOn: $darkMode)
                    ])
                    
                    // Stats
                    statsSection
                    
                    // Danger zone
                    dangerZone
                    
                    // About
                    aboutSection
                    
                    // Version
                    versionInfo
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .alert("Reset All Data?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will delete all your progress, scores, and mood entries. This action cannot be undone.")
        }
    }
    
    // MARK: - Components
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("⚙️ SETTINGS")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Configure your chaos experience")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            // Animated gear
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 40))
                .foregroundColor(.jokerPurple)
                .rotationEffect(.degrees(animateGear ? 360 : 0))
                .onAppear {
                    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                        animateGear = true
                    }
                }
        }
        .padding()
        .glassEffect()
    }
    
    private func settingsSection(title: String, items: [SettingsToggle]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    items[index]
                    
                    if index < items.count - 1 {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
            .padding()
            .glassEffect()
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("STATISTICS")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 16) {
                StatRow(title: "High Score", value: "\(gameState.highScore)", icon: "🏆")
                StatRow(title: "Current Chaos", value: "\(Int(gameState.chaosLevel * 100))%", icon: "🔥")
                StatRow(title: "Cards in Deck", value: "\(gameState.cardDeck.count)", icon: "🎴")
                StatRow(title: "Achievements", value: "\(gameState.unlockedAchievements.count)/\(Achievement.allAchievements.count)", icon: "⭐")
            }
            .padding()
            .glassEffect()
        }
    }
    
    private var dangerZone: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DANGER ZONE")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.jokerRed.opacity(0.7))
            
            Button(action: {
                showResetConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 18))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset All Data")
                            .font(.system(size: 16, weight: .bold))
                        Text("Delete all progress and start fresh")
                            .font(.system(size: 12))
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .opacity(0.5)
                }
                .foregroundColor(.jokerRed)
                .padding()
                .background(Color.jokerRed.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.jokerRed.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ABOUT")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 12) {
                AboutRow(title: "Rate App", icon: "star.fill", action: {})
                AboutRow(title: "Share App", icon: "square.and.arrow.up", action: {})
                AboutRow(title: "Privacy Policy", icon: "lock.shield.fill", action: {})
                AboutRow(title: "Terms of Service", icon: "doc.text.fill", action: {})
            }
            .padding()
            .glassEffect()
        }
    }
    
    private var versionInfo: some View {
        VStack(spacing: 8) {
            Text("🃏")
                .font(.system(size: 40))
                .opacity(0.3)
            
            Text("JOK LAIR")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.3))
            
            Text("Version 1.0.0")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.2))
            
            Text("\"Why so serious?\"")
                .font(.system(size: 11, weight: .medium, design: .serif))
                .foregroundColor(.jokerPurple.opacity(0.5))
                .italic()
        }
        .padding(.vertical, 30)
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
    
    // MARK: - Actions
    
    private func resetAllData() {
        gameState.resetGame()
        // Clear UserDefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}

// MARK: - Settings Toggle
struct SettingsToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.jokerPurple)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .jokerGreen))
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Stat Row
struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 20))
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}

// MARK: - About Row
struct AboutRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.jokerGreen)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppRouter())
            .environmentObject(GameStateManager())
    }
}
