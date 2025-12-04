import SwiftUI

struct JokerQuote: Identifiable {
    let id = UUID()
    let text: String
    let source: String
}

@MainActor
class QuotesViewModel: ObservableObject {
    @Published var quotes: [JokerQuote] = [
        JokerQuote(
            text: "Madness, as you know, is like gravity. All it takes is a little push.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "Why so serious?",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "I'm not a monster. I'm just ahead of the curve.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "The only sensible way to live in this world is without rules.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "Introduce a little anarchy. Upset the established order, and everything becomes chaos.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "Nobody panics when things go according to plan. Even if the plan is horrifying.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "If you're good at something, never do it for free.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "I believe whatever doesn't kill you, simply makes you... stranger.",
            source: "The Dark Knight"
        ),
        JokerQuote(
            text: "All it takes is one bad day to reduce the sanest man alive to lunacy.",
            source: "The Killing Joke"
        ),
        JokerQuote(
            text: "Smile, because it confuses people. Smile, because it's easier than explaining what is killing you inside.",
            source: "Joker Philosophy"
        ),
        JokerQuote(
            text: "I used to think that my life was a tragedy, but now I realize, it's a comedy.",
            source: "Joker (2019)"
        ),
        JokerQuote(
            text: "The worst part of having a mental illness is people expect you to behave as if you don't.",
            source: "Joker (2019)"
        ),
        JokerQuote(
            text: "Is it just me, or is it getting crazier out there?",
            source: "Joker (2019)"
        ),
        JokerQuote(
            text: "For my whole life, I didn't know if I even really existed. But I do, and people are starting to notice.",
            source: "Joker (2019)"
        ),
        JokerQuote(
            text: "They laugh at me because I'm different. I laugh at them because they're all the same.",
            source: "Joker Philosophy"
        ),
        JokerQuote(
            text: "April sweet is coming in, let the feast of fools begin!",
            source: "The Killing Joke"
        ),
        JokerQuote(
            text: "I'm crazy enough to take on Batman, but the IRS? No, thank you!",
            source: "Batman: The Animated Series"
        ),
        JokerQuote(
            text: "A little madness now and then is relished by the wisest men.",
            source: "Classic Wisdom"
        ),
        JokerQuote(
            text: "In my dream, the world had suffered a terrible disaster. A black haze shut out the sun, and the darkness was alive with the moans and screams of wounded people. Suddenly, a small light appeared in the darkness. It flickered, then grew larger, and I woke up. I was here. In Arkham.",
            source: "Arkham Asylum"
        ),
        JokerQuote(
            text: "Do I really look like a guy with a plan? I'm a dog chasing cars.",
            source: "The Dark Knight"
        )
    ]
    
    @Published var favoriteQuotes: Set<UUID> = []
    
    func toggleFavorite(_ quote: JokerQuote) {
        if favoriteQuotes.contains(quote.id) {
            favoriteQuotes.remove(quote.id)
        } else {
            favoriteQuotes.insert(quote.id)
        }
    }
    
    func isFavorite(_ quote: JokerQuote) -> Bool {
        favoriteQuotes.contains(quote.id)
    }
    
    func getRandomQuote() -> JokerQuote {
        quotes.randomElement() ?? quotes[0]
    }
}
