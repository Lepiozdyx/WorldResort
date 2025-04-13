//
//  ToolsContainerView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct ToolsContainerView: View {
    let type: ToolType
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var draggableState: DraggableState
    
    enum ToolType {
        case food
        case cleaning
        
        var name: String {
            switch self {
            case .food: return "kitchen"
            case .cleaning: return "cleaning"
            }
        }
        
        var image: ImageResource {
            switch self {
            case .food: return .bell
            case .cleaning: return .cleaningBrush
            }
        }
        
        var dragType: DraggableState.DragType {
            switch self {
            case .food: return .bell
            case .cleaning: return .brush
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(type.name)
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .textCase(.uppercase)
            
            HStack {
                ToolCellView(
                    type: type,
                    cooldown: getCooldown(),
                    draggableState: draggableState
                )
                
                ToolCellView(
                    type: type,
                    cooldown: getCooldown(),
                    draggableState: draggableState
                )
            }
        }
        .frame(width: 120, height: 100)
        .background {
            Image(.mainRectangle)
                .resizable()
                .shadow(color: .black, radius: 2, x: 1, y: 1)
        }
    }
    
    private func getCooldown() -> TimeInterval {
        switch type {
        case .food:
            return gameViewModel.foodToolCooldown
        case .cleaning:
            return gameViewModel.cleaningToolCooldown
        }
    }
}

struct ToolCellView: View {
    let type: ToolsContainerView.ToolType
    let cooldown: TimeInterval
    @ObservedObject var draggableState: DraggableState
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 40, height: 50)
                .foregroundStyle(.brownLight)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green, lineWidth: 2)
                }
            
            if cooldown > 0 {
                // Показываем таймер перезарядки инструмента
                Text("\(Int(cooldown))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            } else {
                // Показываем инструмент, который можно перетаскивать
                Image(type.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .opacity(cooldown > 0 ? 0.5 : 1.0)
                    .draggable(
                        type: type.dragType,
                        isEnabled: cooldown <= 0,
                        draggableState: draggableState
                    )
            }
        }
    }
}

#Preview {
    ToolsContainerView(
        type: .food,
        gameViewModel: GameViewModel(),
        draggableState: DraggableState()
    )
}
