//
//  RoomType.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

enum RoomType: String, CaseIterable, Identifiable {
    case single = "Single"
    case double = "Double"
    case family = "Family"
    case luxury = "Luxury"
    
    var id: String { self.rawValue }
    
    var count: Int {
        switch self {
        case .single, .double:
            return 4
        case .family, .luxury:
            return 2
        }
    }
}

enum RoomStatus {
    case available
    case occupied
    case dirty
    case needsFood
    
    var color: Color {
        switch self {
        case .available:
            return .green
        case .occupied:
            return .red
        case .dirty:
            return .yellow
        case .needsFood:
            return .blue
        }
    }
}

struct Room: Identifiable {
    let id = UUID()
    let type: RoomType
    let number: Int
    var status: RoomStatus = .available
    var currentGuest: Guest?
    var stayTimeRemaining: TimeInterval?
    var cleaningTimeRemaining: TimeInterval?
    
    func canAccommodate(guest: Guest) -> Bool {
        // Комната должна быть доступна
        guard status == .available else { return false }
        
        // Проверка, может ли гость заселиться в этот тип комнаты
        return guest.type.suitableRoomTypes.contains(type)
    }
}

// Расширение для инициализации комнат
extension Room {
    static func generateRoomNumbers() -> [RoomType: [Int]] {
        return [
            .single: Array(101...104),
            .double: Array(201...204),
            .family: Array(301...302),
            .luxury: Array(401...402)
        ]
    }
    
    static func createAllRooms() -> [Room] {
        var rooms: [Room] = []
        let roomNumbers = generateRoomNumbers()
        
        for type in RoomType.allCases {
            for number in roomNumbers[type]! {
                rooms.append(Room(type: type, number: number))
            }
        }
        
        return rooms
    }
}
