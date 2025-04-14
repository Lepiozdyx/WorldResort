//
//  GameView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    @Binding var appState: AppState
    @StateObject private var draggableState = DraggableState()
    @StateObject private var shopManager = ShopManager.shared
    
    var body: some View {
        ZStack {
            // Фон
            MainBackView()
            
            // Верхняя панель (пауза и монеты)
            TopBarView(amount: gameViewModel.coinBalance) {
                appState = .pause
                gameViewModel.togglePause()
            }
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    ForEach(shopManager.items.filter { $0.isPurchased }) { item in
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                }
                Spacer()
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
                                        draggableState: draggableState
                                    )
                                    .id(room.id)
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
                                        draggableState: draggableState
                                    )
                                    .id(room.id)
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
                                        draggableState: draggableState
                                    )
                                    .id(room.id)
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
                                        draggableState: draggableState
                                    )
                                    .id(room.id)
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
                    GuestView(
                        guest: guest,
                        draggableState: draggableState,
                        onRoomKeyDropped: { roomNumber, roomType in
                            // Обработка сброса ключа на гостя
                            if let room = gameViewModel.rooms.first(where: { $0.roomNumber == roomNumber }) {
                                return gameViewModel.checkInGuest(to: room)
                            }
                            return false
                        }
                    )
                    .offset(x: -40, y: 80) // гость наполовину скрыт
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
                        draggableState: draggableState
                    )
                    
                    ToolsContainerView(
                        type: .cleaning,
                        gameViewModel: gameViewModel,
                        draggableState: draggableState
                    )
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 8)
            
            // Слой с перетаскиваемыми элементами (над всем остальным)
            DragOverlayView(draggableState: draggableState)
        }
        .ignoresSafeArea(edges: .bottom) // Чтобы гость мог заходить за нижний край
        .onAppear {
            if appState != .pause {
                gameViewModel.startGame()
            }
        }
        .onDisappear {
            if appState == .menu {
                gameViewModel.resetGame()
            }
        }
    }
}

// MARK: - Previews
#Preview {
    GameView(appState: .constant(.game))
        .environmentObject(GameViewModel())
}
