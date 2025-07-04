//
//  BuildingButton.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

struct BuildingButton: View {
    let building: BuildingType
    let isAnimated: Bool
    let action: () -> Void
    
    @State private var isPulsing = false
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                // Основное изображение здания
                buildingImageView
                    .overlay(alignment: .topTrailing) {
                        if building.isBuilt {
                            incomeBadgeView
                        }
                    }
                
                if !building.isBuilt {
                    constructionOverlay
                }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimated)
        .onAppear {
            if building.canUpgrade {
                startPulsingAnimation()
            }
        }
    }
    
    private var buildingImageView: some View {
        Image(building.imageName, bundle: nil)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 400)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
            .opacity(building.isBuilt ? 1.0 : 0.75)
    }
    
    private var incomeBadgeView: some View {
        VStack(spacing: -7) {
            Image(.badge)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            Image(.mainRectangle)
                .resizable()
                .frame(width: 50, height: 20)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
                .overlay {
                    HStack(spacing: 4) {
                        Image(.coin)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        
                        Text("\(building.coinsPerDay)")
                            .font(.system(size: 10, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .textCase(.uppercase)
                    }
                }
        }
    }
    
    private var constructionOverlay: some View {
        Image(systemName: "hammer.fill")
            .font(.system(size: 24))
            .foregroundStyle(.yellow)
    }
    
    private func startPulsingAnimation() {
        isPulsing = true
    }
}

#Preview {
    VStack {
        BuildingButton(
            building: BuildingType(
                id: "garden",
                name: "Garden",
                description: "Test",
                imageName: "garden",
                level: 5
            ),
            isAnimated: true,
            action: {}
        )
        
        BuildingButton(
            building: BuildingType(
                id: "boilerroom",
                name: "Boiler room",
                description: "Test",
                imageName: "boilerroom",
                level: 0
            ),
            isAnimated: true,
            action: {}
        )
    }
}
