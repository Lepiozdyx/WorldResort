//
//  MenuView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MainBackView()
                
                VStack(spacing: 20) {
                    // Ежедневное задание
                    ActionView(name: .greenCapsule, text: "accommodate 5 guests", maxWidth: 300, maxHeight: 70)
                    
                    Spacer()
                    
                    // Кнопка Start
                    NavigationLink {
                        GameView()
                            .environmentObject(gameViewModel)
                    } label: {
                        ActionView(name: .mainRectangle, text: "start", maxWidth: 180, maxHeight: 55)
                    }

                    // Нижний ряд кнопок
                    HStack(spacing: 10) {
                        NavigationLink {
                            Text("Progress Screen")
                                .foregroundStyle(.white)
                        } label: {
                            ActionView(name: .mainRectangle, text: "progress", maxWidth: 180, maxHeight: 55)
                        }
                        
                        NavigationLink {
                            Text("Settings Screen")
                                .foregroundStyle(.white)
                        } label: {
                            ActionView(name: .mainRectangle, text: "settings", maxWidth: 180, maxHeight: 55)
                        }
                        
                        NavigationLink {
                            Text("Shop Screen")
                                .foregroundStyle(.white)
                        } label: {
                            ActionView(name: .mainRectangle, text: "shop", maxWidth: 180, maxHeight: 55)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            gameViewModel.resetGame()
        }
    }
}

#Preview {
    MenuView()
}
