//
//  ProgressScreenView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct ProgressScreenView: View {
    @Binding var appState: AppState
    @StateObject private var viewModel = ProgressViewModel()
    
    var body: some View {
        ZStack {
            MainBackView()
            Color.black.opacity(0.6).ignoresSafeArea()
            
            MenuCircleButtonView(appState: $appState)
            
            ZStack {
                Image(.mainRectangle)
                    .resizable()
                    .frame(width: 500, height: 300)
                    .overlay {
                        HStack {
                            Button {
                                viewModel.showPreviousAchievement()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .opacity(viewModel.isAtFirstAchievement ? 0 : 1)
                            
                            Spacer()
                            
                            Button {
                                viewModel.showNextAchievement()
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                            .opacity(viewModel.isAtLastAchievement ? 0 : 1)
                        }
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.brownLight)
                        .padding(.horizontal)
                    }
                
                if let achievement = viewModel.currentAchievement {
                    VStack(spacing: 20) {
                        Text("Progress")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .textCase(.uppercase)
                        
                        VStack {
                            Text(achievement.title)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            Text(achievement.description)
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            if achievement.isCompleted {
                                ActionView(name: .greenCapsule, text: "Done", maxWidth: 170, maxHeight: 40)
                            } else {
                                ActionView(name: .redCapsule, text: "Not completed", maxWidth: 170, maxHeight: 40)
                            }
                            
                            // Индикатор прогресса
                            Text("\(achievement.progress)/\(achievement.requirement)")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 350)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black.opacity(0.5))
                        )
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadAchievements()
        }
    }
}

#Preview {
    ProgressScreenView(appState: .constant(.progress))
}
