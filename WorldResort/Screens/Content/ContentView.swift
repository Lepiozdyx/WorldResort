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
    @StateObject private var manager = SettingsManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            switch appState {
            case .menu:
                MenuView(appState: $appState)
                    .environmentObject(gameViewModel)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            case .game:
                GameView(appState: $appState)
                    .environmentObject(gameViewModel)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            case .pause:
                GameView(appState: $appState)
                    .environmentObject(gameViewModel)
                    .overlay {
                        PauseView(appState: $appState)
                            .environmentObject(gameViewModel)
                    }
            case .settings:
                SettingsView(appState: $appState)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            case .rules:
                RulesView(appState: $appState)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            case .shop:
                ShopView(appState: $appState)
                    .environmentObject(gameViewModel)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            case .progress:
                ProgressScreenView(appState: $appState)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            case .farm:
                FarmView(appState: $appState)
                    .environmentObject(gameViewModel)
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            }
        }
        .onAppear {
            if manager.isMusicOn {
                manager.playMusic()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                manager.playMusic()
            case .background, .inactive:
                manager.stopMusic()
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
