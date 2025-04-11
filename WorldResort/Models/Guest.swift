//
//  GuestType.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import SwiftUI

enum GuestType: String, CaseIterable {
    case couple = "Couple"
    case business = "Business"
    case family = "Family"
    case vip = "VIP"
    
    var coinReward: Int {
        switch self {
        case .couple:
            return 10
        case .business:
            return 15
        case .family:
            return 20
        case .vip:
            return 50
        }
    }
    
    var suitableRoomTypes: [RoomType] {
        switch self {
        case .couple:
            return [.single, .double, .family]
        case .business:
            return [.single]
        case .family:
            return [.family]
        case .vip:
            return [.luxury]
        }
    }
    
    var preferredRoomType: RoomType {
        switch self {
        case .couple:
            return .double
        case .business:
            return .single
        case .family:
            return .family
        case .vip:
            return .luxury
        }
    }
    
    var randomImage: ImageResource {
        switch self {
        case .couple:
            return [.youngCouple, .elderCouple].randomElement()!
        case .business:
            return [.businessman, .businesswoman].randomElement()!
        case .family:
            return [.familyBig, .familyMedium].randomElement()!
        case .vip:
            return .sheikh
        }
    }
    
    static var spawnWeights: [GuestType: Double] {
        return [
            .couple: 0.3,
            .business: 0.3,
            .family: 0.3,
            .vip: 0.1
        ]
    }
    
    static func randomType() -> GuestType {
        let totalWeight = spawnWeights.values.reduce(0, +)
        let randomValue = Double.random(in: 0..<totalWeight)
        
        var runningTotal = 0.0
        for (type, weight) in spawnWeights {
            runningTotal += weight
            if randomValue < runningTotal {
                return type
            }
        }
        
        return .couple
    }
}

struct Guest: Identifiable {
    let id = UUID()
    let type: GuestType
    let image: ImageResource
    var patienceTimeRemaining: TimeInterval
    var hasLeft = false
    
    init(type: GuestType) {
        self.type = type
        self.image = type.randomImage
        self.patienceTimeRemaining = 15 // 15 секунд терпения по умолчанию
    }
}
