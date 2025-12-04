import SwiftUI

@MainActor
class FortuneTellerViewModel: ObservableObject {
    @Published var revealedFortune: Fortune?
    @Published var fortuneHistory: [Fortune] = []
    @Published var isConsulting: Bool = false
    
    private let fortunes = Fortune.allFortunes
    
    func revealFortune() {
        guard !isConsulting else { return }
        isConsulting = true
        
        // Select a random fortune
        if let fortune = fortunes.randomElement() {
            revealedFortune = fortune
            fortuneHistory.append(fortune)
        }
        
        isConsulting = false
    }
    
    func reset() {
        revealedFortune = nil
    }
    
    func getFortuneCount() -> Int {
        fortuneHistory.count
    }
    
    func getAverageChaosRating() -> Double {
        guard !fortuneHistory.isEmpty else { return 0 }
        let total = fortuneHistory.reduce(0) { $0 + $1.chaosRating }
        return Double(total) / Double(fortuneHistory.count)
    }
}
