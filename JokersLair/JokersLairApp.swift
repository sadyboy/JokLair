//
//  JokersLairApp.swift
//  JokersLair
//
//  Created by Serhii Anp on 02.12.2025.
//

import SwiftUI

//@main
struct JokersLairApp: View {
    @StateObject private var appRouter = AppRouter()
    @StateObject private var gameState = GameStateManager()
    var body: some View {
        VStack {
            ContentView()
                .environmentObject(appRouter)
                .environmentObject(gameState)
                .preferredColorScheme(.dark)
        }
    }
}
