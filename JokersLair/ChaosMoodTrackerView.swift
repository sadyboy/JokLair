import SwiftUI

struct ChaosMoodTrackerView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = ChaosMoodViewModel()
    @State private var selectedChaosLevel: ChaosLevel = .sane
    
    var body: some View {
        ZStack {
            
            // Background
            Color.black.ignoresSafeArea()
            
            // Animated chaos background
            ChaosBackgroundView()
            
            VStack(spacing: 20) {
                ScrollView {
                    // Header
                    HStack {
                        Button(action: {
                            router.goBack()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.jokerPurple)
                        }
                        
                        Spacer()
                        
                        Text("CHAOS MOOD TRACKER")
                            .font(.custom("AvenirNext-Bold", size: 22))
                            .foregroundColor(.white)
                            .shadow(color: .jokerPurple, radius: 5)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.saveCurrentMood(level: selectedChaosLevel)
                        }) {
                            Image(systemName: "checkmark.circle")
                                .font(.title2)
                                .foregroundColor(.jokerGreen)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Current mood display
                    VStack(spacing: 15) {
                        Text("CURRENT MOOD")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(viewModel.currentMoodDescription)
                            .font(.custom("AvenirNext-Bold", size: 32))
                            .foregroundColor(selectedChaosLevel.color)
                            .shadow(color: selectedChaosLevel.color.opacity(0.5), radius: 10)
                            .multilineTextAlignment(.center)
                            .frame(height: 100)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient(
                                colors: [.jokerPurple, .jokerGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            ), lineWidth: 2)
                    )
                    .padding(.horizontal)
                    
                    // Chaos level selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SELECT CHAOS LEVEL")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        ForEach(ChaosLevel.allCases, id: \.self) { level in
                            ChaosLevelButton(
                                level: level,
                                isSelected: selectedChaosLevel == level,
                                action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedChaosLevel = level
                                    }
                                    viewModel.playChaosSound(for: level)
                                }
                            )
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.jokerPurple.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Mood history
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("MOOD HISTORY")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button("Clear All") {
                                viewModel.clearHistory()
                            }
                            .font(.caption)
                            .foregroundColor(.jokerGreen)
                        }
                        
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(viewModel.moodHistory.reversed()) { moodEntry in
                                    MoodHistoryRow(entry: moodEntry)
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.jokerGreen.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Joker's advice
                    if let advice = viewModel.getJokerAdvice(for: selectedChaosLevel) {
                        Text("«\(advice)»")
                            .font(.custom("AvenirNext-Italic", size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.jokerPurple.opacity(0.2))
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - View Models
class ChaosMoodViewModel: ObservableObject {
    @Published var moodHistory: [MoodEntrys] = []
    @Published var currentMoodDescription: String = "Calculating chaos..."
    
    private let adviceDatabase = JokerAdviceDatabase()
    
    init() {
        loadHistory()
        updateCurrentMood()
    }
    
    func saveCurrentMood(level: ChaosLevel) {
        let entry = MoodEntrys(
            date: Date(),
            chaosLevel: level,
            description: level.getRandomDescription()
        )
        moodHistory.append(entry)
        saveHistory()
        updateCurrentMood()
        
        // Trigger haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func clearHistory() {
        moodHistory.removeAll()
        saveHistory()
        updateCurrentMood()
    }
    
    func getJokerAdvice(for level: ChaosLevel) -> String? {
        return adviceDatabase.getRandomAdvice(for: level)
    }
    
    func playChaosSound(for level: ChaosLevel) {
        // В реальном приложении здесь было бы воспроизведение звука
        print("Playing chaos sound for \(level)")
    }
    
    private func updateCurrentMood() {
        if let latest = moodHistory.last {
            currentMoodDescription = latest.description
        } else {
            currentMoodDescription = "Why so serious? Start tracking!"
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(moodHistory) {
            UserDefaults.standard.set(encoded, forKey: "chaosMoodHistory")
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "chaosMoodHistory"),
           let decoded = try? JSONDecoder().decode([MoodEntrys].self, from: data) {
            moodHistory = decoded
        }
    }
}

// MARK: - Models
enum ChaosLevel: String, CaseIterable, Codable {
    case sane = "SANE"
    case mischievous = "MISCHIEVOUS"
    case chaotic = "CHAOTIC"
    case insane = "INSANE"
    case legendary = "LEGENDARY"
    
    var color: Color {
        switch self {
        case .sane: return .blue
        case .mischievous: return .yellow
        case .chaotic: return .orange
        case .insane: return .red
        case .legendary: return .jokerPurple
        }
    }
    
    var icon: String {
        switch self {
        case .sane: return "brain.head.profile"
        case .mischievous: return "smiley"
        case .chaotic: return "bolt"
        case .insane: return "brain"
        case .legendary: return "crown"
        }
    }
    
    func getRandomDescription() -> String {
        let descriptions: [String]
        switch self {
        case .sane:
            descriptions = [
                "Boring... Let's spice things up",
                "Too predictable",
                "Where's the fun?"
            ]
        case .mischievous:
            descriptions = [
                "Just a little prank won't hurt",
                "Time to cause some trouble",
                "Let's play a game"
            ]
        case .chaotic:
            descriptions = [
                "Everything burns!",
                "Complete madness!",
                "Society deserves this"
            ]
        case .insane:
            descriptions = [
                "HAHAHAHAHAHA!",
                "Why so serious?",
                "Let's watch the world burn"
            ]
        case .legendary:
            descriptions = [
                "AGENT OF CHAOS",
                "MASTER OF MADNESS",
                "THE JOKER'S LEGACY"
            ]
        }
        return descriptions.randomElement() ?? self.rawValue
    }
}
//
//struct MoodEntry: Identifiable, Codable {
//    let id = UUID()
//    let date: Date
//    let chaosLevel: ChaosLevel
//    let description: String
//}

// MARK: - Custom Views
struct ChaosLevelButton: View {
    let level: ChaosLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: level.icon)
                    .font(.title2)
                    .foregroundColor(level.color)
                
                Text(level.rawValue)
                    .font(.custom("AvenirNext-Bold", size: 18))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(level.color)
                        .frame(width: 12, height: 12)
                        .shadow(color: level.color, radius: 5)
                }
            }
            .padding()
            .background(
                isSelected ?
                AnyView(LinearGradient(
                    colors: [level.color.opacity(0.2), level.color.opacity(0.05)],
                    startPoint: .leading,
                    endPoint: .trailing
                )) : AnyView(Color.clear)
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? level.color : Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
    }
}
struct MoodEntrys: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let chaosLevel: ChaosLevel
    let description: String
}
struct MoodHistoryRow: View {
    let entry: MoodEntrys
    
    var body: some View {
        HStack {
            Circle()
                .fill(entry.chaosLevel.color)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.description)
                    .font(.custom("AvenirNext-Medium", size: 14))
                    .foregroundColor(.white)
                
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(entry.chaosLevel.rawValue)
                .font(.caption)
                .foregroundColor(entry.chaosLevel.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(entry.chaosLevel.color.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
}

struct ChaosBackgroundView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        Canvas { context, size in
            for particle in particles {
                context.opacity = particle.opacity
                context.fill(
                    Circle().path(in: CGRect(
                        x: particle.x,
                        y: particle.y,
                        width: particle.size,
                        height: particle.size
                    )),
                    with: .color(particle.color)
                )
            }
        }
        .onAppear {
            // Создаем частицы хаоса
            particles = (0..<50).map { _ in
                Particle(
                    x: Double.random(in: 0...UIScreen.main.bounds.width),
                    y: Double.random(in: 0...UIScreen.main.bounds.height),
                    size: Double.random(in: 2...8),
                    color: [Color.jokerPurple, Color.jokerGreen, Color.red, Color.yellow].randomElement()!,
                    opacity: Double.random(in: 0.1...0.5)
                )
            }
            
            // Анимация частиц
            withAnimation(.easeInOut(duration: 3).repeatForever()) {
                for i in particles.indices {
                    particles[i].x += Double.random(in: -50...50)
                    particles[i].y += Double.random(in: -50...50)
                    particles[i].opacity = Double.random(in: 0.1...0.7)
                }
            }
        }
    }
}

struct Particle {
    var x: Double
    var y: Double
    var size: Double
    var color: Color
    var opacity: Double
}

// MARK: - Advice Database
class JokerAdviceDatabase {
    private let advice: [ChaosLevel: [String]] = [
        .sane: [
            "Why so serious?",
            "Smile! It's all a joke anyway",
            "Let's put a smile on that face"
        ],
        .mischievous: [
            "A little chaos is good for the soul",
            "Let's see how far we can push them",
            "The night is young, and so is the madness"
        ],
        .chaotic: [
            "Introduce a little anarchy!",
            "This town deserves a better class of criminal",
            "If you're good at something, never do it for free"
        ],
        .insane: [
            "Madness is the emergency exit",
            "I believe whatever doesn't kill you makes you... stranger",
            "Do I really look like a guy with a plan?"
        ],
        .legendary: [
            "We stopped looking for monsters under our bed when we realized they were inside us",
            "I'm an agent of chaos",
            "You complete me"
        ]
    ]
    
    func getRandomAdvice(for level: ChaosLevel) -> String? {
        return advice[level]?.randomElement()
    }
}

// MARK: - Color Extension
extension Color {
   
}

#Preview {
    ChaosMoodTrackerView()
        .environmentObject(AppRouter())
}
