//
//  DraggedItemView.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

struct DragInfo: Identifiable {
    let id = UUID()
    let type: DragType
    var offset: CGSize = .zero
    var roomNumber: Int?
    var isDragging: Bool = false
    var startPosition: CGPoint = .zero
    
    enum DragType {
        case key(RoomType)
        case bell
        case brush
    }
}

struct DraggableKeyView: View {
    let roomType: RoomType
    let roomNumber: Int
    @Binding var dragInfo: DragInfo?
    
    var body: some View {
        Image(.keys)
            .resizable()
            .scaledToFit()
            .frame(width: 35)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if dragInfo == nil {
                            dragInfo = DragInfo(
                                type: .key(roomType),
                                roomNumber: roomNumber,
                                isDragging: true,
                                startPosition: value.startLocation
                            )
                        }
                        
                        if var info = dragInfo, info.roomNumber == roomNumber {
                            info.offset = value.translation
                            dragInfo = info
                        }
                    }
            )
    }
}

struct DraggableBellView: View {
    @Binding var dragInfo: DragInfo?
    let isDisabled: Bool
    
    var body: some View {
        Image(.bell)
            .resizable()
            .scaledToFit()
            .frame(width: 35)
            .opacity(isDisabled ? 0.5 : 1.0)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if isDisabled { return }
                        
                        if dragInfo == nil {
                            dragInfo = DragInfo(
                                type: .bell,
                                isDragging: true,
                                startPosition: value.startLocation
                            )
                        }
                        
                        if var info = dragInfo, case .bell = info.type {
                            info.offset = value.translation
                            dragInfo = info
                        }
                    }
            )
    }
}

struct DraggableBrushView: View {
    @Binding var dragInfo: DragInfo?
    let isDisabled: Bool
    
    var body: some View {
        Image(.cleaningBrush)
            .resizable()
            .scaledToFit()
            .frame(width: 35)
            .opacity(isDisabled ? 0.5 : 1.0)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if isDisabled { return }
                        
                        if dragInfo == nil {
                            dragInfo = DragInfo(
                                type: .brush,
                                isDragging: true,
                                startPosition: value.startLocation
                            )
                        }
                        
                        if var info = dragInfo, case .brush = info.type {
                            info.offset = value.translation
                            dragInfo = info
                        }
                    }
                    .onEnded { _ in
                        // Обработка завершения перетаскивания происходит в GameView
                    }
            )
    }
}

struct DraggedItemView: View {
    let dragInfo: DragInfo
    
    var body: some View {
        Group {
            switch dragInfo.type {
            case .key:
                Image(.keys)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            case .bell:
                Image(.bell)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            case .brush:
                Image(.cleaningBrush)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
        }
        .position(x: dragInfo.startPosition.x + dragInfo.offset.width,
                  y: dragInfo.startPosition.y + dragInfo.offset.height)
    }
}

// MARK: - Previews
#Preview {
    let dragInfo = DragInfo(
        type: .key(.single),
        isDragging: true,
        startPosition: CGPoint(x: 150, y: 150)
    )
    
    DraggedItemView(dragInfo: dragInfo)
}
