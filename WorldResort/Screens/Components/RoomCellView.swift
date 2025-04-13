//
//  RoomCellView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct RoomCellView: View {
    @ObservedObject var roomViewModel: RoomViewModel
    @Binding var dragInfo: DragInfo?
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 50)
                    .foregroundStyle(.brownLight)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(roomViewModel.status.color, lineWidth: 2)
                    }
                
                roomContent
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
            DraggableKeyView(
                roomType: roomViewModel.roomType,
                roomNumber: roomViewModel.roomNumber,
                dragInfo: $dragInfo
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
}

// MARK: - Previews
#Preview {
    RoomCellView(
        roomViewModel: RoomViewModel(room: Room(type: .luxury, number: 401)), dragInfo: .constant(nil)
    )
}
