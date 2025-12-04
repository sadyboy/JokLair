import SwiftUI
import Combine

// MARK: - Game State Manager (Main ViewModel)
@MainActor
class GameStateManager: ObservableObject {
    // MARK: - Published Properties
    @Published var playerScore: Int = 0
    @Published var highScore: Int = 0
    @Published var currentMood: JokerMood = .chaotic
    @Published var dailyFortune: Fortune?
    @Published var cardDeck: [PlayingCard] = []
    @Published var unlockedAchievements: Set<Achievement> = []
    @Published var chaosLevel: Double = 0.5
    @Published var isAnimating: Bool = false
    
    // MARK: - User Defaults Keys
    private enum StorageKeys {
        static let highScore = "joker_high_score"
        static let chaosLevel = "chaos_level"
        static let achievements = "achievements"
    }
    
    // MARK: - Initialization
    init() {
        loadSavedData()
        generateDeck()
    }
    
    // MARK: - Game Logic
    func generateDeck() {
        var newDeck: [PlayingCard] = []
        for suit in CardSuit.allCases {
            for rank in CardRank.allCases {
                newDeck.append(PlayingCard(suit: suit, rank: rank))
            }
        }
        // Add 2 Jokers
        newDeck.append(PlayingCard(suit: .joker, rank: .joker))
        newDeck.append(PlayingCard(suit: .joker, rank: .joker))
        
        cardDeck = newDeck.shuffled()
    }
    
    func shuffleDeck() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            isAnimating = true
            cardDeck.shuffle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isAnimating = false
        }
    }
    
    func drawCard() -> PlayingCard? {
        guard !cardDeck.isEmpty else {
            generateDeck()
            return cardDeck.popLast()
        }
        return cardDeck.popLast()
    }
    
    func updateScore(by points: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            playerScore += points
            if playerScore > highScore {
                highScore = playerScore
                saveData()
            }
        }
    }
    
    func updateChaosLevel(_ delta: Double) {
        withAnimation(.easeInOut(duration: 0.5)) {
            chaosLevel = max(0, min(1, chaosLevel + delta))
            updateMoodBasedOnChaos()
            saveData()
        }
    }
    
    private func updateMoodBasedOnChaos() {
        switch chaosLevel {
        case 0..<0.2:
            currentMood = .calm
        case 0.2..<0.4:
            currentMood = .mischievous
        case 0.4..<0.6:
            currentMood = .chaotic
        case 0.6..<0.8:
            currentMood = .maniacal
        default:
            currentMood = .unhinged
        }
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        guard !unlockedAchievements.contains(achievement) else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            unlockedAchievements.insert(achievement)
        }
        saveData()
    }
    
    // MARK: - Fortune Generation
    func generateDailyFortune() {
        let fortunes = Fortune.allFortunes
        dailyFortune = fortunes.randomElement()
    }
    
    // MARK: - Persistence
    private func saveData() {
        UserDefaults.standard.set(highScore, forKey: StorageKeys.highScore)
        UserDefaults.standard.set(chaosLevel, forKey: StorageKeys.chaosLevel)
    }
    
    private func loadSavedData() {
        highScore = UserDefaults.standard.integer(forKey: StorageKeys.highScore)
        chaosLevel = UserDefaults.standard.double(forKey: StorageKeys.chaosLevel)
        if chaosLevel == 0 { chaosLevel = 0.5 }
        updateMoodBasedOnChaos()
    }
    
    func resetGame() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            playerScore = 0
            chaosLevel = 0.5
            generateDeck()
            updateMoodBasedOnChaos()
        }
    }
}
