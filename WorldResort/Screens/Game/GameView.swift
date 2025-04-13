//
//  GameView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    @State private var dragInfo: DragInfo?
    @State private var isPausePresented = false
    @State private var guestWishRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            // Фон
            MainBackView()
            
            // Верхняя панель (пауза и монеты)
            TopBarView(amount: gameViewModel.coinBalance) {
                isPausePresented = true
                gameViewModel.togglePause()
            }
            
            // Центральная часть с комнатами
            VStack {
                Spacer()
                
                HStack(spacing: 30) {
                    // Левая колонка комнат
                    VStack(spacing: 15) {
                        // Single Rooms
                        VStack {
                            Text("single")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(gameViewModel.rooms(of: .single)) { room in
                                    RoomCellView(
                                        roomViewModel: room,
                                        dragInfo: $dragInfo
                                    )
                                    .id(room.id)
                                    .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
                                        return handleDrop(for: room, providers: providers)
                                    }
                                }
                            }
                        }
                        
                        // Family Rooms
                        VStack {
                            Text("family")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(gameViewModel.rooms(of: .family)) { room in
                                    RoomCellView(
                                        roomViewModel: room,
                                        dragInfo: $dragInfo
                                    )
                                    .id(room.id)
                                    .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
                                        return handleDrop(for: room, providers: providers)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Правая колонка комнат
                    VStack(spacing: 15) {
                        // Double Rooms
                        VStack {
                            Text("double")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(gameViewModel.rooms(of: .double)) { room in
                                    RoomCellView(
                                        roomViewModel: room,
                                        dragInfo: $dragInfo
                                    )
                                    .id(room.id)
                                    .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
                                        return handleDrop(for: room, providers: providers)
                                    }
                                }
                            }
                        }
                        
                        // Luxury Rooms
                        VStack {
                            Text("luxury")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(gameViewModel.rooms(of: .luxury)) { room in
                                    RoomCellView(
                                        roomViewModel: room,
                                        dragInfo: $dragInfo
                                    )
                                    .id(room.id)
                                    .onDrop(of: ["public.text"], isTargeted: nil) { providers, location in
                                        return handleDrop(for: room, providers: providers)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: 400)
                
                Spacer()
                Spacer()
                Spacer()
            }
            
            // Левая часть - гость внизу
            VStack {
                Spacer()
                
                if let guest = gameViewModel.currentGuest {
                    GuestView(guest: guest)
                        .offset(x: -60, y: 80) // гость наполовину скрыт
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Правая часть - инструменты посередине
            VStack {
                Spacer()
                
                // Контейнеры с инструментами
                VStack(spacing: 6) {
                    ToolsContainerView(
                        type: .food,
                        gameViewModel: gameViewModel,
                        dragInfo: $dragInfo
                    )
                    
                    ToolsContainerView(
                        type: .cleaning,
                        gameViewModel: gameViewModel,
                        dragInfo: $dragInfo
                    )
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 8)
            
            // Перетаскиваемый элемент
            if let info = dragInfo, info.isDragging {
                DraggedItemView(dragInfo: info)
                    .onDisappear {
                        // При исчезновении элемента сбрасываем dragInfo
                        DispatchQueue.main.async {
                            self.dragInfo = nil
                        }
                    }
            }
        }
        .ignoresSafeArea(edges: .bottom) // Чтобы гость мог заходить за нижний край
        .navigationBarBackButtonHidden(true)
        .onAppear {
            gameViewModel.startGame()
        }
        .onDisappear {
            gameViewModel.resetGame()
        }
        .overlay {
            if isPausePresented {
                PauseView(isPresented: $isPausePresented)
                    .environmentObject(gameViewModel)
            }
        }
    }
    
    private func handleDropOnGuest(providers: [NSItemProvider]) -> Bool {
        guard let info = dragInfo,
              case .key(_) = info.type,
              let roomNumber = info.roomNumber,
              let room = gameViewModel.rooms.first(where: { $0.roomNumber == roomNumber }),
              let guest = gameViewModel.currentGuest,
              !guest.hasLeft else {
            return false
        }
        
        // Проверяем, соответствует ли тип комнаты желанию гостя
        let result = gameViewModel.checkInGuest(to: room)
        dragInfo = nil
        return result
    }
    
    private func handleDrop(for room: RoomViewModel, providers: [NSItemProvider]) -> Bool {
        guard let info = dragInfo else { return false }
        
        if case .bell = info.type, room.status == .needsFood {
            let result = gameViewModel.serveFood(to: room)
            dragInfo = nil
            return result
        }
        else if case .brush = info.type, room.status == .dirty {
            let result = gameViewModel.cleanRoom(roomViewModel: room)
            dragInfo = nil
            return result
        }
        
        return false
    }
}

// MARK: - Previews
#Preview {
    GameView()
        .environmentObject(GameViewModel())
}
