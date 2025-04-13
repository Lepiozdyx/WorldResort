//
//  PauseView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct PauseView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("PAUSED")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                
                Button {
                    // Снимаем с паузы и закрываем оверлей
                    gameViewModel.togglePause()
                    isPresented = false
                } label: {
                    ActionView(name: .mainRectangle, text: "Resume", maxWidth: 220, maxHeight: 65)
                }
                .buttonStyle(.plain)
                
                Button {
                    // Останавливаем игру, обнуляем состояния, выходим в главное меню
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

// MARK: - Previews
#Preview {
    PauseView(isPresented: .constant(true))
        .environmentObject(GameViewModel())
}
