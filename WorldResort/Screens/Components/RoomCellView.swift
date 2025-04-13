//
//  RoomCellView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct RoomCellView: View {
    @ObservedObject var roomViewModel: RoomViewModel
    @ObservedObject var draggableState: DraggableState
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 50)
                    .foregroundStyle(.brownLight)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(roomViewModel.status.color, lineWidth: 3)
                            .shadow(color: roomViewModel.status.color, radius: 1)
                    }
                
                roomContent
            }
            .dropTarget(
                isActive: roomViewModel.status == .dirty || roomViewModel.status == .needsFood,
                draggableState: draggableState
            ) { dragType in
                // Обработка сброса щетки или колокольчика на комнату
                switch dragType {
                case .brush:
                    return handleBrushDrop()
                case .bell:
                    return handleBellDrop()
                default:
                    return false
                }
            }
            
            Text("\(roomViewModel.roomNumber)")
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    private var roomContent: some View {
        if roomViewModel.status == .available {
            // Показываем ключ только для доступной комнаты
            Image(.keys)
                .resizable()
                .scaledToFit()
                .frame(width: 35)
                .draggable(
                    type: .key(roomNumber: roomViewModel.roomNumber, roomType: roomViewModel.roomType),
                    draggableState: draggableState
                )
        } else if let timeRemaining = roomViewModel.stayTimeRemaining, timeRemaining > 0 {
            // Показываем таймер проживания
            Text("\(Int(timeRemaining))")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
        } else if let timeRemaining = roomViewModel.cleaningTimeRemaining, timeRemaining > 0 {
            // Показываем таймер уборки
            Text("\(Int(timeRemaining))")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
        }
    }
    
    private func handleBrushDrop() -> Bool {
        // Вызываем метод очистки комнаты из RoomViewModel
        return roomViewModel.cleanRoom()
    }
    
    private func handleBellDrop() -> Bool {
        // Вызываем метод подачи еды из RoomViewModel
        return roomViewModel.serveFood()
    }
}

#Preview {
    RoomCellView(
        roomViewModel: RoomViewModel(room: Room(type: .luxury, number: 401)),
        draggableState: DraggableState()
    )
}
