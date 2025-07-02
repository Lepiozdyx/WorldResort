//
//  BuildingButton.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

struct BuildingButton: View {
    let building: Building?
    let imageName: ImageResource
    let size: CGFloat
    let isAnimated: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 4) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: size)
                    .overlay(alignment: .topTrailing) {
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
                                    HStack(spacing: 0) {
                                        Image(.coin)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(2)
                                        
                                        // Отображаем текущий доход от здания, который зависит от уровня улучшения
                                        Text("50")
                                            .font(.system(size: 12, weight: .bold, design: .default))
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.center)
                                            .textCase(.uppercase)
                                    }
                                }
                        }
                    }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1.0 : 0)
    }
}

#Preview {
    BuildingButton(
        building: Building.boilerroom,
        imageName: .boilerroom,
        size: 150,
        isAnimated: true,
        action: {}
    )
    .background(Color.gray)
}
