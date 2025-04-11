//
//  GameState.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import Foundation
import Combine

class GameState {
    var rooms: [Room]
    var currentGuest: Guest?
    var isGamePaused = false
    var coinBalance = 0
    
    init() {
        rooms = Room.createAllRooms()
    }
    
    func resetGame() {
        rooms = Room.createAllRooms()
        currentGuest = nil
        isGamePaused = false
    }
    
    func findAvailableRoom(of type: RoomType) -> Room? {
        return rooms.first { $0.type == type && $0.status == .available }
    }
    
    func findSuitableRooms(for guest: Guest) -> [Room] {
        return rooms.filter { $0.canAccommodate(guest: guest) }
    }
    
    func hasSuitableRooms(for guest: Guest) -> Bool {
        return !findSuitableRooms(for: guest).isEmpty
    }
    
    func findRoom(byNumber number: Int) -> Room? {
        return rooms.first { $0.number == number }
    }
    
    func updateRoom(_ updatedRoom: Room) {
        if let index = rooms.firstIndex(where: { $0.id == updatedRoom.id }) {
            rooms[index] = updatedRoom
        }
    }
}
