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
    @State private var isPulsing = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MainBackView()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        appState = .farm
                    } label: {
                        Image(.hotelbuilding)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .shadow(color: .yellow.opacity(0.5), radius: 5, x: 2, y: 2)
                            .overlay(alignment: .bottom) {
                                ActionView(name: .redCapsule, text: "hotel", maxWidth: 100, maxHeight: 30)
                            }
                    }
                    .soundButton()
                    .scaleEffect(isPulsing ? 1.05 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                }
                Spacer()
            }
            .padding()
            
            VStack(spacing: 20) {
                DailyTaskView()
                
                Spacer()
                
                // Кнопка Start
                Button {
                    gameViewModel.resetGame()
                    gameViewModel.startGame()
                    appState = .game
                } label: {
                    ActionView(name: .mainRectangle, text: "start", maxWidth: 180, maxHeight: 55)
                }
                .soundButton()

                // Нижний ряд кнопок
                HStack(spacing: 10) {
                    Button {
                        appState = .progress
                    } label: {
                        ActionView(name: .mainRectangle, text: "progress", maxWidth: 180, maxHeight: 55)
                    }
                    .soundButton()
                    
                    Button {
                        appState = .settings
                    } label: {
                        ActionView(name: .mainRectangle, text: "settings", maxWidth: 180, maxHeight: 55)
                    }
                    .soundButton()
                    
                    Button {
                        appState = .shop
                    } label: {
                        ActionView(name: .mainRectangle, text: "shop", maxWidth: 180, maxHeight: 55)
                    }
                    .soundButton()
                }
            }
            .padding()
        }
        .onAppear {
            gameViewModel.resetGame()
            isPulsing = true
        }
    }
}

#Preview {
    MenuView(appState: .constant(.menu))
        .environmentObject(GameViewModel())
}
