import SwiftUI

@MainActor
class MoodTrackerViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []
    
    private let storageKey = "mood_entries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(_ entry: MoodEntry) {
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    func removeEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        saveEntries()
    }
    
    func getAverageChaos() -> Double {
        guard !entries.isEmpty else { return 0 }
        let total = entries.reduce(0.0) { $0 + $1.chaosLevel }
        return total / Double(entries.count)
    }
    
    func getMostCommonMood() -> String? {
        let moodCounts = Dictionary(grouping: entries, by: { $0.mood })
            .mapValues { $0.count }
        return moodCounts.max(by: { $0.value < $1.value })?.key
    }
    
    func getEntriesForToday() -> [MoodEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDateInToday($0.timestamp) }
    }
    
    func getEntriesForWeek() -> [MoodEntry] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return entries.filter { $0.timestamp >= weekAgo }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            entries = decoded
        }
    }
}
