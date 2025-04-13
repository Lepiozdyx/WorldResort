//
//  DragOverlayView.swift
//  WorldResort
//
//  Created by Alex on 13.04.2025.
//

import SwiftUI

struct DragOverlayView: View {
    @ObservedObject var draggableState: DraggableState
    
    var body: some View {
        ZStack {
            if let drag = draggableState.currentDrag {
                switch drag.type {
                case .key:
                    Image(.keys)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .position(drag.position)
                        .transition(.opacity)
                        .zIndex(100)
                
                case .bell:
                    Image(.bell)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .position(drag.position)
                        .transition(.opacity)
                        .zIndex(100)
                    
                case .brush:
                    Image(.cleaningBrush)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .position(drag.position)
                        .transition(.opacity)
                        .zIndex(100)
                }
            }
        }
        .animation(.easeInOut(duration: 0.1), value: draggableState.currentDrag != nil)
    }
}

#Preview {
    let draggableState = DraggableState()
    
    // Симулируем перетаскивание ключа для предпросмотра
    DispatchQueue.main.async {
        draggableState.startDragging(
            type: .key(roomNumber: 101, roomType: .single),
            position: CGPoint(x: 200, y: 200)
        )
    }
    
    return DragOverlayView(draggableState: draggableState)
}
