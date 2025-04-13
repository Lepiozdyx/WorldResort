//
//  MenuView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    @Binding var appState: AppState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MainBackView()
            
            VStack(spacing: 20) {
                // Ежедневное задание
                ActionView(name: .greenCapsule, text: "accommodate 5 guests", maxWidth: 300, maxHeight: 70)
                
                Spacer()
                
                // Кнопка Start
                Button {
                    gameViewModel.resetGame()
                    gameViewModel.startGame()
                    appState = .game
                } label: {
                    ActionView(name: .mainRectangle, text: "start", maxWidth: 180, maxHeight: 55)
                }

                // Нижний ряд кнопок
                HStack(spacing: 10) {
                    Button {
                        // Navigate to Progress Screen
                    } label: {
                        ActionView(name: .mainRectangle, text: "progress", maxWidth: 180, maxHeight: 55)
                    }
                    
                    Button {
                        // Navigate to Settings Screen
                    } label: {
                        ActionView(name: .mainRectangle, text: "settings", maxWidth: 180, maxHeight: 55)
                    }
                    
                    Button {
                        // Navigate to Shop Screen
                    } label: {
                        ActionView(name: .mainRectangle, text: "shop", maxWidth: 180, maxHeight: 55)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            gameViewModel.resetGame()
        }
    }
}

#Preview {
    MenuView(appState: .constant(.menu))
        .environmentObject(GameViewModel())
}
