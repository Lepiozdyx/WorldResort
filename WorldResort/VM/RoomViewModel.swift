//
//  RoomViewModel.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import Foundation
import Combine
import SwiftUI

class RoomViewModel: ObservableObject, Identifiable {
    let id: UUID
    let roomNumber: Int
    let roomType: RoomType
    
    @Published var status: RoomStatus
    @Published var stayTimeRemaining: TimeInterval?
    @Published var cleaningTimeRemaining: TimeInterval?
    @Published var currentGuest: Guest?
    @Published var needsService = false
    
    var didCheckoutGuest: ((Guest) -> Void)?
    var didCompleteCleaningRoom: ((RoomViewModel) -> Void)?
    private var serviceRequestTimer: AnyCancellable?
    
    init(room: Room) {
        self.id = room.id
        self.roomNumber = room.number
        self.roomType = room.type
        self.status = room.status
        self.currentGuest = room.currentGuest
        self.stayTimeRemaining = room.stayTimeRemaining
        self.cleaningTimeRemaining = room.cleaningTimeRemaining
    }
    
    func canAccommodate(guest: Guest) -> Bool {
        guard status == .available else { return false }
        return guest.type.suitableRoomTypes.contains(roomType)
    }
    
    func checkInGuest(_ guest: Guest) {
        currentGuest = guest
        status = .occupied
        stayTimeRemaining = GameConstants.guestStayTime
        
        scheduleServiceRequest()
    }
    
    private func scheduleServiceRequest() {
        serviceRequestTimer?.cancel()
        
        serviceRequestTimer = Timer.publish(every: GameConstants.guestServiceRequestDelay, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                guard let self = self, self.status == .occupied else { return }
                
                // 50% шанс запроса сервиса
                if Double.random(in: 0...1) < 0.5 {
                    // Определение запроса: еда или уборка (50/50)
                    if Bool.random() {
                        self.status = .needsFood
                    } else {
                        self.status = .dirty
                    }
                    self.needsService = true
                }
            }
    }
    
    func serveFood() -> Bool {
        guard status == .needsFood else { return false }
        
        status = .occupied
        needsService = false
        return true
    }
    
    func cleanRoom() -> Bool {
        // Очистка занятой грязной комнаты
        if status == .dirty && currentGuest != nil {
            status = .occupied
            needsService = false
            return true
        }
        
        // Очистка пустой грязной комнаты
        if status == .dirty && currentGuest == nil {
            cleaningTimeRemaining = GameConstants.roomCleaningTime
            return true
        }
        
        return false
    }
    
    func updateTimers(deltaTime: TimeInterval) {
        // Обновление таймера проживания
        if let remainingTime = stayTimeRemaining, remainingTime > 0 {
            stayTimeRemaining = remainingTime - deltaTime
            
            // Выселение гостя
            if stayTimeRemaining! <= 0 {
                checkoutGuest()
            }
        }
        
        // Обновление таймера уборки
        if let remainingTime = cleaningTimeRemaining, remainingTime > 0 {
            cleaningTimeRemaining = remainingTime - deltaTime
            
            // Уборка завершена
            if cleaningTimeRemaining! <= 0 {
                cleaningCompleted()
            }
        }
    }
    
    private func checkoutGuest() {
        guard let guest = currentGuest else { return }
        
        // Комната становится грязной после выселения
        status = .dirty
        
        // Вызов колбэка для награждения монетами
        didCheckoutGuest?(guest)
        
        // Очистка гостя
        currentGuest = nil
        stayTimeRemaining = nil
    }
    
    private func cleaningCompleted() {
        status = .available
        cleaningTimeRemaining = nil
        
        // Уведомление о завершении
        didCompleteCleaningRoom?(self)
    }
    
    func resetRoom() {
        status = .available
        currentGuest = nil
        stayTimeRemaining = nil
        cleaningTimeRemaining = nil
        needsService = false
        serviceRequestTimer?.cancel()
    }
}
