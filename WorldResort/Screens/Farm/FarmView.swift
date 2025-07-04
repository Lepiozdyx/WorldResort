//
//  FarmView.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

struct FarmView: View {
    @Binding var appState: AppState
    @EnvironmentObject private var gameViewModel: GameViewModel
    @StateObject private var farmViewModel = FarmViewModel()
    @StateObject private var buildingManager = BuildingManager.shared
    
    @State private var animateBuildings = false
    
    var body: some View {
        ZStack {
            // Фон
            MainBackView(image: .farmbg)
            
            topBarView
            
            buildingsGridView
            
            VStack {
                Spacer()
                
                dailyRewardButtonView
            }
            .padding()
            
            if farmViewModel.showBuildingDetail {
                buildingDetailOverlay
            }
            
            ManagerRepliesView(
                replyText: farmViewModel.currentManagerReply,
                isVisible: farmViewModel.showManagerReply
            )
        }
        .onAppear {
            setupFarmView()
        }
    }
    
    // MARK: - Top Bar
    
    private var topBarView: some View {
        VStack {
            HStack(alignment: .top) {
                MenuCircleButtonView(appState: $appState)
                
                Spacer()
                
                CoinCounterView(amount: gameViewModel.coinBalance)
                    .padding(8)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Buildings Grid
    
    private var buildingsGridView: some View {
        VStack {
            Spacer()
            Spacer()
            // Первый ряд: Boiler room + Garden
            HStack(spacing: 50) {
                Spacer()
                buildingButtonView(for: "boilerroom")
                buildingButtonView(for: "garden")
                Spacer()
                Spacer()
            }
            
            // Второй ряд: Library + Warehouse
            HStack(spacing: 50) {
                Spacer()
                Spacer()
                buildingButtonView(for: "library")
                buildingButtonView(for: "warehouse")
                Spacer()
            }
            Spacer()
        }
    }
    
    private func buildingButtonView(for buildingId: String) -> some View {
        Group {
            if let building = farmViewModel.getBuildingById(buildingId) {
                BuildingButton(
                    building: building,
                    isAnimated: animateBuildings,
                    action: {
                        farmViewModel.selectBuilding(building)
                    }
                )
            } else {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150)
            }
        }
    }
    
    // MARK: - Daily Reward Button
    
    private var dailyRewardButtonView: some View {
        VStack {
            let rewardInfo = farmViewModel.getDailyRewardInfo()
            
            if rewardInfo.canClaim && rewardInfo.amount > 0 {
                Button {
                    claimDailyReward()
                } label: {
                    HStack(spacing: 8) {
                        Image(.coin)
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("CLAIM \(rewardInfo.amount)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .textCase(.uppercase)
                    }
                    .frame(maxWidth: 250, maxHeight: 60)
                    .background(
                        Image(.greenCapsule)
                            .resizable()
                            .shadow(color: .black, radius: 3, x: 2, y: 2)
                    )
                }
                .soundButton()
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: rewardInfo.canClaim)
            }
        }
        .frame(height: 80)
    }
    
    // MARK: - Building Detail Overlay
    
    private var buildingDetailOverlay: some View {
        Group {
            if let selectedBuilding = farmViewModel.selectedBuilding {
                BuildingDetailView(
                    building: selectedBuilding,
                    currentCoins: gameViewModel.coinBalance,
                    onUpgrade: {
                        return farmViewModel.upgradeSelectedBuilding(gameViewModel: gameViewModel)
                    },
                    onClose: {
                        farmViewModel.closeBuildingDetail()
                    }
                )
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupFarmView() {
        farmViewModel.showWelcomeMessageIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animateBuildings = true
            }
        }
    }
    
    private func claimDailyReward() {
        let _ = farmViewModel.claimDailyReward(gameViewModel: gameViewModel)
    }
}

#Preview {
    FarmView(appState: .constant(.farm))
        .environmentObject(GameViewModel())
}
