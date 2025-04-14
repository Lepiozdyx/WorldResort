//
//  PauseView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct PauseView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Binding var appState: AppState
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("PAUSED")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                
                Button {
                    // Снимаем с паузы и возвращаемся в игру
                    gameViewModel.togglePause()
                    appState = .game
                } label: {
                    ActionView(name: .mainRectangle, text: "Resume", maxWidth: 220, maxHeight: 65)
                }
                .buttonStyle(.plain)
                
                Button {
                    // Останавливаем игру, обнуляем состояния, выходим в главное меню
                    gameViewModel.resetGame()
                    appState = .menu
                } label: {
                    ActionView(name: .mainRectangle, text: "Menu", maxWidth: 220, maxHeight: 65)
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            // Обязательно останавливаем игру при появлении
            if !gameViewModel.isGamePaused {
                gameViewModel.togglePause()
            }
        }
    }
}

#Preview {
    PauseView(appState: .constant(.pause))
        .environmentObject(GameViewModel())
}
