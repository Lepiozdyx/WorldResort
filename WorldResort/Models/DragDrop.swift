//
//  DragDrop.swift
//  WorldResort
//
//  Created by Alex on 13.04.2025.
//

import SwiftUI

// Класс для хранения информации о перетаскиваемых объектах
class DraggableState: ObservableObject {
    // Типы перетаскиваемых объектов
    enum DragType: Equatable {
        case key(roomNumber: Int, roomType: RoomType)
        case bell
        case brush
        
        static func == (lhs: DragType, rhs: DragType) -> Bool {
            switch (lhs, rhs) {
            case (.bell, .bell):
                return true
            case (.brush, .brush):
                return true
            case let (.key(lhsNumber, lhsType), .key(rhsNumber, rhsType)):
                return lhsNumber == rhsNumber && lhsType == rhsType
            default:
                return false
            }
        }
    }
    
    // Структура для хранения информации о перетаскивании
    struct DragInfo: Equatable {
        let type: DragType
        var position: CGPoint
        
        static func == (lhs: DragInfo, rhs: DragInfo) -> Bool {
            return lhs.type == rhs.type &&
                   lhs.position.x == rhs.position.x &&
                   lhs.position.y == rhs.position.y
        }
    }
    
    // Текущий перетаскиваемый объект
    @Published var currentDrag: DragInfo? = nil
    
    // Метод для начала перетаскивания
    func startDragging(type: DragType, position: CGPoint) {
        currentDrag = DragInfo(type: type, position: position)
    }
    
    // Метод для обновления позиции
    func updatePosition(to position: CGPoint) {
        guard let drag = currentDrag else { return }
        currentDrag = DragInfo(type: drag.type, position: position)
    }
    
    // Метод для окончания перетаскивания
    func stopDragging() {
        currentDrag = nil
    }
}

// Модификатор для определения попадания в зону
struct DropTargetModifier: ViewModifier {
    let isActive: Bool
    let dragType: DraggableState.DragType?
    let onDrop: (DraggableState.DragType) -> Bool
    @ObservedObject var draggableState: DraggableState
    @State private var isTargeted = false
    @State private var previousDrag: DraggableState.DragInfo? = nil
    @State private var dropTargetRect: CGRect = .zero
    
    func body(content: Content) -> some View {
        content
            .background(
                // Невидимый прямоугольник для определения размеров и положения dropTarget
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: DropTargetPreferenceKey.self, value: geometry.frame(in: .global))
                        .onPreferenceChange(DropTargetPreferenceKey.self) { rect in
                            dropTargetRect = rect
                        }
                }
            )
            .onChange(of: draggableState.currentDrag) { newValue in
                // Сохраняем старое значение
                let oldValue = previousDrag
                // Обновляем для следующего раза
                previousDrag = newValue
                
                // Проверяем находится ли перетаскиваемый объект над целью
                if let drag = newValue {
                    isTargeted = dropTargetRect.contains(drag.position)
                } else if oldValue != nil && newValue == nil && isTargeted {
                    // Если перетаскивание закончилось и мы находимся над целью
                    if let oldDrag = oldValue {
                        let success = onDrop(oldDrag.type)
                        // Если не успешно, возвращаем объект
                        if !success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                draggableState.startDragging(type: oldDrag.type, position: oldDrag.position)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    draggableState.stopDragging()
                                }
                            }
                        }
                    }
                    isTargeted = false
                } else {
                    isTargeted = false
                }
            }
    }
}

// PreferenceKey для передачи размеров и положения dropTarget
struct DropTargetPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// Модификатор для добавления перетаскивания
struct DraggableModifier: ViewModifier {
    let type: DraggableState.DragType
    let isEnabled: Bool
    @ObservedObject var draggableState: DraggableState
    
    func body(content: Content) -> some View {
        content
            .opacity(draggableState.currentDrag?.type != type ? 1 : 0) // Скрываем исходный объект при перетаскивании
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        if !isEnabled { return }
                        
                        if draggableState.currentDrag == nil {
                            // Начинаем перетаскивание
                            draggableState.startDragging(type: type, position: value.location)
                        } else {
                            // Обновляем позицию
                            draggableState.updatePosition(to: value.location)
                        }
                    }
                    .onEnded { _ in
                        if !isEnabled { return }
                        
                        // Останавливаем перетаскивание
                        draggableState.stopDragging()
                    }
            )
    }
}

// Вспомогательные расширения для модификаторов
extension View {
    func draggable(type: DraggableState.DragType, isEnabled: Bool = true, draggableState: DraggableState) -> some View {
        modifier(DraggableModifier(type: type, isEnabled: isEnabled, draggableState: draggableState))
    }
    
    func dropTarget(isActive: Bool = true, dragType: DraggableState.DragType? = nil, draggableState: DraggableState, onDrop: @escaping (DraggableState.DragType) -> Bool) -> some View {
        modifier(DropTargetModifier(isActive: isActive, dragType: dragType, onDrop: onDrop, draggableState: draggableState))
    }
}
