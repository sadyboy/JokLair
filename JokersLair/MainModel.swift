import SwiftUI

// MARK: - Joker Mood
enum JokerMood: String, CaseIterable {
    case calm = "Suspiciously Calm"
    case mischievous = "Mischievous"
    case chaotic = "Chaotic"
    case maniacal = "Maniacal"
    case unhinged = "Completely Unhinged"
    
    var emoji: String {
        switch self {
        case .calm: return "🃏"
        case .mischievous: return "😏"
        case .chaotic: return "🤪"
        case .maniacal: return "😈"
        case .unhinged: return "🔥"
        }
    }
    
    var color: Color {
        switch self {
        case .calm: return .jokerGreen.opacity(0.6)
        case .mischievous: return .jokerGreen
        case .chaotic: return .jokerPurple
        case .maniacal: return .jokerRed
        case .unhinged: return .jokerGold
        }
    }
    
    var description: String {
        switch self {
        case .calm:
            return "The calm before the storm... or just a really good poker face."
        case .mischievous:
            return "Something wicked this way comes... but it's probably just a prank."
        case .chaotic:
            return "Why so serious? Let's put a smile on that face!"
        case .maniacal:
            return "HAHAHAHA! The joke's on everyone!"
        case .unhinged:
            return "All it takes is one bad day... Welcome to the show!"
        }
    }
}

// MARK: - Playing Card
enum CardSuit: String, CaseIterable {
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    case spades = "♠️"
    case joker = "🃏"
    
    var color: Color {
        switch self {
        case .hearts, .diamonds: return .jokerRed
        case .clubs, .spades: return .white
        case .joker: return .jokerPurple
        }
    }
}

enum CardRank: String, CaseIterable {
    case ace = "A"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "J"
    case queen = "Q"
    case king = "K"
    case joker = "JOKER"
    
    var value: Int {
        switch self {
        case .ace: return 14
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        case .joker: return 100
        }
    }
}

struct PlayingCard: Identifiable, Equatable {
    let id = UUID()
    let suit: CardSuit
    let rank: CardRank
    var isFlipped: Bool = false
    var rotation: Double = 0
    var offset: CGSize = .zero
    
    var displayName: String {
        if rank == .joker {
            return "🃏 JOKER 🃏"
        }
        return "\(rank.rawValue)\(suit.rawValue)"
    }
    
    var isJoker: Bool {
        rank == .joker
    }
    
    static func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Fortune
struct Fortune: Identifiable {
    let id = UUID()
    let text: String
    let chaosRating: Int // 1-5
    let category: FortuneCategory
    
    enum FortuneCategory: String, CaseIterable {
        case chaos = "Chaos"
        case wisdom = "Twisted Wisdom"
        case warning = "Warning"
        case opportunity = "Dark Opportunity"
        case mystery = "Mystery"
    }
    
    static var allFortunes: [Fortune] {
        [
            Fortune(text: "Madness, as you know, is like gravity. All it takes is a little push.", chaosRating: 5, category: .wisdom),
            Fortune(text: "The only sensible way to live in this world is without rules.", chaosRating: 4, category: .chaos),
            Fortune(text: "Smile, because it confuses people. Smile, because it's easier than explaining what's killing you inside.", chaosRating: 3, category: .wisdom),
            Fortune(text: "If you're good at something, never do it for free.", chaosRating: 2, category: .opportunity),
            Fortune(text: "Nobody panics when things go according to plan. Even if the plan is horrifying.", chaosRating: 4, category: .warning),
            Fortune(text: "Introduce a little anarchy. Upset the established order, and everything becomes chaos.", chaosRating: 5, category: .chaos),
            Fortune(text: "I'm not a monster. I'm just ahead of the curve.", chaosRating: 3, category: .wisdom),
            Fortune(text: "A wild card appears in your future. Play it wisely... or don't.", chaosRating: 4, category: .mystery),
            Fortune(text: "Today, let chaos be your compass.", chaosRating: 5, category: .chaos),
            Fortune(text: "The best jokes are the ones nobody expects.", chaosRating: 2, category: .mystery),
            Fortune(text: "Your sanity called. It's not coming back.", chaosRating: 4, category: .warning),
            Fortune(text: "Fortune favors the bold... and the completely unhinged.", chaosRating: 5, category: .opportunity),
            Fortune(text: "Today's tragedy is tomorrow's comedy. Give it time.", chaosRating: 3, category: .wisdom),
            Fortune(text: "The cards are stacked against you. Good thing you've got a Joker up your sleeve.", chaosRating: 4, category: .opportunity),
            Fortune(text: "Some people want to watch the world burn. Today, bring marshmallows.", chaosRating: 5, category: .chaos),
        ]
    }
}

// MARK: - Achievement
struct Achievement: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let icon: String
    
    static let allAchievements: [Achievement] = [
        Achievement(id: "first_chaos", title: "Chaos Initiate", description: "Welcome to the madness", icon: "🎭"),
        Achievement(id: "draw_joker", title: "Wild Card", description: "Drew your first Joker", icon: "🃏"),
        Achievement(id: "high_score_100", title: "Laughing All the Way", description: "Score 100 points", icon: "😂"),
        Achievement(id: "max_chaos", title: "Agent of Chaos", description: "Reach maximum chaos level", icon: "🔥"),
        Achievement(id: "fortune_master", title: "Prophet of Madness", description: "Read 10 fortunes", icon: "🔮"),
        Achievement(id: "card_master", title: "Dealer of Doom", description: "Play 50 cards", icon: "♠️"),
    ]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mood Entry
struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let mood: String
    let chaosLevel: Double
    let note: String
    let timestamp: Date
    
    init(id: UUID = UUID(), mood: String, chaosLevel: Double, note: String, timestamp: Date = Date()) {
        self.id = id
        self.mood = mood
        self.chaosLevel = chaosLevel
        self.note = note
        self.timestamp = timestamp
    }
}

// MARK: - Menu Item
struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let route: AppRoute
    let gradientColors: [Color]
}
