//
//  GuestView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct GuestView: View {
    let guest: Guest
    @ObservedObject var draggableState: DraggableState
    let onRoomKeyDropped: (Int, RoomType) -> Bool
    
    var body: some View {
        VStack(spacing: 0) {
            wishBubbleView
                .offset(y: 20)
                .zIndex(1) // Поместить облачко поверх для лучшего улавливания
            
            Image(guest.image)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
        }
    }
    
    @ViewBuilder
    private var wishBubbleView: some View {
        if !guest.hasLeft {
            Image(.wishes)
                .resizable()
                .frame(width: 150, height: 120)
                .overlay(
                    Text("\(guest.type.preferredRoomType.rawValue) room please!")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .offset(y: -15)
                        .padding(.horizontal, 8)
                )
                .dropTarget(draggableState: draggableState) { dragType in
                    switch dragType {
                    case let .key(roomNumber, roomType):
                        return onRoomKeyDropped(roomNumber, roomType)
                    default:
                        return false
                    }
                }
        }
    }
}

#Preview {
    GuestView(
        guest: Guest(type: .business),
        draggableState: DraggableState(),
        onRoomKeyDropped: { _, _ in return true }
    )
}
