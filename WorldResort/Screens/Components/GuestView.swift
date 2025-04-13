//
//  GuestView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct GuestView: View {
    let guest: Guest
    var dropTarget: CGRect = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            wishBubbleView
                .offset(y: 20)
            
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
                .overlay {
                    Text("\(guest.type.preferredRoomType.rawValue) room please!")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .offset(y: -15)
                        .padding(.horizontal, 8)
                }
        }
    }
    
//    func getWishBubbleFrame(in geometry: GeometryProxy) -> CGRect {
//        // Создаем область для определения попадания при перетаскивании
//        let frame = geometry.frame(in: .global)
//        return CGRect(
//            x: frame.origin.x,
//            y: frame.origin.y - 70,
//            width: 150,
//            height: 100
//        )
//    }
}

// MARK: - Previews
#Preview {
    GuestView(guest: Guest(type: .business))
}
