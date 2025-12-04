import SwiftUI
import SpriteKit

// MARK: - Game Phase
enum GamePhase {
    case waiting
    case guessing
    case revealed
    case gameOver
}

// MARK: - Guess Result
struct GuessResult {
    let won: Bool
    let message: String
}

// MARK: - Card Game ViewModel
@MainActor
class CardGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentCard: PlayingCard?
    @Published var nextCard: PlayingCard?
    @Published var isNextCardRevealed: Bool = false
    @Published var gamePhase: GamePhase = .waiting
    @Published var currentScore: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var cardsRemaining: Int = 54
    @Published var wildCardsRemaining: Int = 2
    @Published var lastPointsEarned: Int = 0
    
    // MARK: - Game Scene
    let gameScene: CardGameScene
    
    // MARK: - Private Properties
    private var deck: [PlayingCard] = []
    private weak var gameState: GameStateManager?
    
    // MARK: - Initialization
    init() {
        gameScene = CardGameScene(size: CGSize(width: 400, height: 800))
        gameScene.scaleMode = .resizeFill
    }
    
    func setup(with gameState: GameStateManager) {
        self.gameState = gameState
        resetGame()
    }
    
    // MARK: - Game Logic
    func resetGame() {
        generateDeck()
        currentCard = nil
        nextCard = nil
        isNextCardRevealed = false
        gamePhase = .waiting
        currentScore = 0
        currentStreak = 0
        wildCardsRemaining = 2
        cardsRemaining = deck.count
    }
    
    private func generateDeck() {
        var newDeck: [PlayingCard] = []
        for suit in CardSuit.allCases where suit != .joker {
            for rank in CardRank.allCases where rank != .joker {
                newDeck.append(PlayingCard(suit: suit, rank: rank))
            }
        }
        // Add Jokers
        newDeck.append(PlayingCard(suit: .joker, rank: .joker))
        newDeck.append(PlayingCard(suit: .joker, rank: .joker))
        
        deck = newDeck.shuffled()
    }
    
    func drawCards() {
        guard !deck.isEmpty else {
            gamePhase = .gameOver
            return
        }
        
        if currentCard == nil {
            currentCard = deck.popLast()
        } else {
            currentCard = nextCard
        }
        
        if !deck.isEmpty {
            nextCard = deck.popLast()
            isNextCardRevealed = false
            gamePhase = .guessing
        } else {
            gamePhase = .gameOver
        }
        
        cardsRemaining = deck.count
        
        // Trigger SpriteKit animation
        gameScene.animateCardDraw()
    }
    
    func makeGuess(higher: Bool) -> GuessResult {
        guard let current = currentCard, let next = nextCard else {
            return GuessResult(won: false, message: "No cards!")
        }
        
        // Reveal the next card
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isNextCardRevealed = true
        }
        
        // Handle Joker (wild card - always wins)
        if next.isJoker {
            gameScene.animateJokerAppearance()
            handleWin(isJoker: true)
            return GuessResult(won: true, message: "🃏 JOKER! The Chaos God smiles upon you!")
        }
        
        // Compare values
        let currentValue = current.rank.value
        let nextValue = next.rank.value
        
        let isCorrect: Bool
        if higher {
            isCorrect = nextValue >= currentValue
        } else {
            isCorrect = nextValue <= currentValue
        }
        
        if isCorrect {
            handleWin(isJoker: false)
            gameScene.animateWin()
            return GuessResult(won: true, message: getWinMessage())
        } else {
            handleLoss()
            gameScene.animateLoss()
            return GuessResult(won: false, message: getLossMessage())
        }
    }
    
    private func handleWin(isJoker: Bool) {
        currentStreak += 1
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        
        // Calculate points with streak bonus
        let basePoints = isJoker ? 50 : 10
        let streakBonus = currentStreak * 5
        lastPointsEarned = basePoints + streakBonus
        currentScore += lastPointsEarned
        
        // Prepare for next round
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.gamePhase = .waiting
        }
    }
    
    private func handleLoss() {
        currentStreak = 0
        lastPointsEarned = 0
        
        // Check if game over
        if deck.isEmpty {
            gamePhase = .gameOver
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.gamePhase = .waiting
            }
        }
    }
    
    func useWildCard() {
        guard wildCardsRemaining > 0, gamePhase == .guessing else { return }
        
        wildCardsRemaining -= 1
        
        // Wild card reveals the next card without penalty
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isNextCardRevealed = true
        }
        
        gameScene.animateWildCardUse()
        
        // After seeing, player can make an informed choice
        // Reset to guessing phase after a moment
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isNextCardRevealed = false
        }
    }
    
    // MARK: - Messages
    private func getWinMessage() -> String {
        let messages = [
            "Excellent! The chaos favors you!",
            "Hahaha! You're getting it!",
            "The cards dance to your tune!",
            "Madness and luck intertwined!",
            "Fortune smiles... for now!",
            "Keep riding the chaos wave!",
            "You've got the Joker's touch!"
        ]
        return messages.randomElement() ?? "You win!"
    }
    
    private func getLossMessage() -> String {
        let messages = [
            "The joke's on you!",
            "Chaos is unpredictable...",
            "Even madness has its limits!",
            "The cards have spoken!",
            "Better luck next draw!",
            "Why so serious about losing?",
            "The Joker laughs at your misfortune!"
        ]
        return messages.randomElement() ?? "You lose!"
    }
}

// MARK: - SpriteKit Game Scene
class CardGameScene: SKScene {
    // Background particles
    private var particleEmitter: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        setupParticles()
    }
    
    private func setupParticles() {
        // Create custom particle emitter for chaos effect
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(imageNamed: "spark")
        emitter.particleBirthRate = 5
        emitter.particleLifetime = 3
        emitter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        emitter.particleSpeed = 50
        emitter.particleSpeedRange = 30
        emitter.particleAlpha = 0.3
        emitter.particleAlphaSpeed = -0.1
        emitter.particleScale = 0.1
        emitter.particleScaleRange = 0.05
        emitter.particleColor = .systemPurple
        emitter.particleColorBlendFactor = 1
        emitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        particleEmitter = emitter
        addChild(emitter)
    }
    
    // MARK: - Animations
    func animateCardDraw() {
        // Create burst effect
        createBurstEffect(at: CGPoint(x: size.width / 2, y: size.height / 2), color: .systemGreen)
    }
    
    func animateWin() {
        // Celebration particles
        for _ in 0..<20 {
            let particle = createParticle(color: .systemGreen)
            particle.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(particle)
            
            let angle = CGFloat.random(in: 0...CGFloat.pi * 2)
            let distance: CGFloat = 200
            let destination = CGPoint(
                x: particle.position.x + cos(angle) * distance,
                y: particle.position.y + sin(angle) * distance
            )
            
            let move = SKAction.move(to: destination, duration: 0.8)
            let fade = SKAction.fadeOut(withDuration: 0.8)
            let scale = SKAction.scale(to: 0.1, duration: 0.8)
            let group = SKAction.group([move, fade, scale])
            let remove = SKAction.removeFromParent()
            
            particle.run(SKAction.sequence([group, remove]))
        }
    }
    
    func animateLoss() {
        // Shake effect
        let shake = SKAction.sequence([
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: -20, y: 0, duration: 0.05),
            SKAction.moveBy(x: 20, y: 0, duration: 0.05),
            SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        ])
        
        self.run(shake)
        
        // Red flash
        let flashNode = SKSpriteNode(color: .systemRed, size: size)
        flashNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        flashNode.alpha = 0.3
        flashNode.zPosition = 100
        addChild(flashNode)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        flashNode.run(SKAction.sequence([fadeOut, remove]))
    }
    
    func animateJokerAppearance() {
        // Massive celebration
        createBurstEffect(at: CGPoint(x: size.width / 2, y: size.height / 2), color: .systemPurple, count: 50)
        
        // Screen flash
        let flashNode = SKSpriteNode(color: .systemPurple, size: size)
        flashNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        flashNode.alpha = 0
        flashNode.zPosition = 100
        addChild(flashNode)
        
        let flashIn = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
        let flashOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        flashNode.run(SKAction.sequence([flashIn, flashOut, remove]))
    }
    
    func animateWildCardUse() {
        // Mysterious reveal effect
        createBurstEffect(at: CGPoint(x: size.width / 2, y: size.height / 2), color: .systemYellow, count: 30)
    }
    
    // MARK: - Helper Methods
    private func createBurstEffect(at position: CGPoint, color: UIColor, count: Int = 20) {
        for _ in 0..<count {
            let particle = createParticle(color: color)
            particle.position = position
            addChild(particle)
            
            let angle = CGFloat.random(in: 0...CGFloat.pi * 2)
            let distance = CGFloat.random(in: 100...250)
            let destination = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            let duration = Double.random(in: 0.5...1.0)
            let move = SKAction.move(to: destination, duration: duration)
            move.timingMode = .easeOut
            let fade = SKAction.fadeOut(withDuration: duration)
            let scale = SKAction.scale(to: 0.1, duration: duration)
            let group = SKAction.group([move, fade, scale])
            let remove = SKAction.removeFromParent()
            
            particle.run(SKAction.sequence([group, remove]))
        }
    }
    
    private func createParticle(color: UIColor) -> SKShapeNode {
        let particle = SKShapeNode(circleOfRadius: CGFloat.random(in: 3...8))
        particle.fillColor = color
        particle.strokeColor = .clear
        particle.glowWidth = 2
        return particle
    }
}
