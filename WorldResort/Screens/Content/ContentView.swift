//
//  ContentView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    @State private var appState: AppState = .menu
    
    var body: some View {
        ZStack {
            switch appState {
            case .menu:
                MenuView(appState: $appState)
                    .environmentObject(gameViewModel)
            case .game:
                GameView(appState: $appState)
                    .environmentObject(gameViewModel)
            case .pause:
                GameView(appState: $appState)
                    .environmentObject(gameViewModel)
                    .overlay {
                        PauseView(appState: $appState)
                            .environmentObject(gameViewModel)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
