//
//  BuildingDetailView.swift
//  WorldResort
//
//  Created by Alex on 03.07.2025.
//

import SwiftUI

struct BuildingDetailView: View {
    let building: BuildingType
    let currentCoins: Int
    let onUpgrade: () -> Bool
    let onClose: () -> Void
    
    @State private var isUpgrading = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            Image(.mainRectangle)
                .resizable()
                .shadow(color: .black, radius: 10, x: 1, y: 5)
                .frame(maxWidth: 500, maxHeight: 300)
                .overlay {
                    VStack(spacing: 16) {
                        headerView
                        
                        contentPanel
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        onClose()
                    } label: {
                        ActionView(name: .redCapsule, text: "X", maxWidth: 50, maxHeight: 40)
                    }
                    .soundButton()
                }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 2) {
            Text(building.name)
                .font(.system(size: 26, weight: .heavy, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Text("Level \(building.level)/5")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    private var contentPanel: some View {
        VStack(spacing: 10) {
            Text(building.description)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundStyle(.brownLight)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            incomeInfoView
            
            upgradeButtonView
        }
    }
    
    private var incomeInfoView: some View {
        VStack(spacing: 8) {
            if building.isBuilt {
                HStack {
                    Text("Current income:")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.brownLight)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(.coin)
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("\(building.coinsPerDay)/day")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.yellow)
                    }
                }
            }
            
            if building.canUpgrade {
                HStack {
                    Text(building.isBuilt ? "Next level income:" : "Income after building:")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.brownLight)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(.coin)
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("\(building.nextLevelCoinsPerDay)/day")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.yellow)
                    }
                }
            }
        }
        .frame(maxWidth: 350)
    }
    
    private var upgradeButtonView: some View {
        Group {
            if building.canUpgrade {
                Button {
                    performUpgrade()
                } label: {
                    HStack(spacing: 8) {
                        if isUpgrading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(.coin)
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("\(building.upgradeCostCoins) - \(building.upgradeButtonText)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.yellow)
                                .textCase(.uppercase)
                        }
                    }
                    .frame(maxWidth: 180, maxHeight: 50)
                    .background(
                        Image(.mainRectangle)
                            .resizable()
                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                    )
                }
                .soundButton()
                .disabled(currentCoins < building.upgradeCostCoins || isUpgrading)
                .opacity(currentCoins < building.upgradeCostCoins ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isUpgrading)
                
            } else {
                ActionView(name: .greenCapsule, text: "MAX LEVEL", maxWidth: 180, maxHeight: 50)
            }
        }
    }
    
    private func performUpgrade() {
        guard !isUpgrading else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isUpgrading = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            _ = onUpgrade()
            
            withAnimation(.easeInOut(duration: 0.3)) {
                isUpgrading = false
            }
        }
    }
}

#Preview {
    BuildingDetailView(
        building: BuildingType(
            id: "garden",
            name: "Garden",
            description: "Speeds up food preparation",
            imageName: "garden",
            level: 1
        ),
        currentCoins: 1500,
        onUpgrade: { return true },
        onClose: {}
    )
}
