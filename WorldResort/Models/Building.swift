//
//  Building.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

enum Building: String, Codable, CaseIterable {
    case boilerroom = "boilerroom"
    case garden = "garden"
    case library = "library"
    case warehouse = "warehouse"
    
    var displayName: String {
        switch self {
        case .boilerroom: return "Boiler room"
        case .garden: return "Garden"
        case .library: return "Library"
        case .warehouse: return "Warehouse"
        }
    }
    
    var replies: String {
        switch self {
        case .boilerroom:
            return "Warm radiators - no cold complaints!"
        case .garden:
            return "Our signature salad made with our carrots—and our customers are delighted!"
        case .library:
            return "Cultural vacations are expensive vacations!"
        case .warehouse:
            return "More shelves means more guests!"
        }
    }
    
    var description: String {
        switch self {
        case .boilerroom:
            return "Speeds up room cleaning and provides warm atmosphere for guests"
        case .garden:
            return "Speeds up food preparation and provides fresh ingredients"
        case .library:
            return "Increases customer satisfaction and cultural experience"
        case .warehouse:
            return "Increases storage capacity and guest waiting time"
        }
    }
}

struct BuildingType: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let imageName: String
    var level: Int
    
    static func == (lhs: BuildingType, rhs: BuildingType) -> Bool {
        return lhs.id == rhs.id
    }
    
    var coinsPerDay: Int {
        return getCoinsPerDay(for: level)
    }
    
    var nextLevelCoinsPerDay: Int {
        guard canUpgrade else { return coinsPerDay }
        return getCoinsPerDay(for: level + 1)
    }
    
    private func getCoinsPerDay(for buildingLevel: Int) -> Int {
        guard buildingLevel > 0 else { return 0 }
        
        switch id {
        case "boilerroom":
            switch buildingLevel {
            case 1: return 50
            case 2: return 70
            case 3: return 90
            case 4: return 100
            case 5: return 130
            default: return 0
            }
        case "garden":
            switch buildingLevel {
            case 1: return 50
            case 2: return 70
            case 3: return 90
            case 4: return 100
            case 5: return 130
            default: return 0
            }
        case "library":
            switch buildingLevel {
            case 1: return 50
            case 2: return 70
            case 3: return 90
            case 4: return 100
            case 5: return 130
            default: return 0
            }
        case "warehouse":
            switch buildingLevel {
            case 1: return 50
            case 2: return 70
            case 3: return 90
            case 4: return 100
            case 5: return 130
            default: return 0
            }
        default: return 0
        }
    }
    
    var upgradeCostCoins: Int {
        let nextLevel = level + 1
        guard nextLevel <= 5 else { return 0 }
        
        switch id {
        case "boilerroom":
            switch nextLevel {
            case 1: return 300
            case 2: return 500
            case 3: return 700
            case 4: return 1200
            case 5: return 2500
            default: return 0
            }
        case "garden":
            switch nextLevel {
            case 1: return 300
            case 2: return 500
            case 3: return 700
            case 4: return 1200
            case 5: return 2500
            default: return 0
            }
        case "library":
            switch nextLevel {
            case 1: return 300
            case 2: return 500
            case 3: return 700
            case 4: return 1200
            case 5: return 2500
            default: return 0
            }
        case "warehouse":
            switch nextLevel {
            case 1: return 300
            case 2: return 500
            case 3: return 700
            case 4: return 1200
            case 5: return 2500
            default: return 0
            }
        default: return 0
        }
    }
    
    var canUpgrade: Bool {
        return level < 5
    }
    
    var isBuilt: Bool {
        return level > 0
    }
    
    var upgradeButtonText: String {
        if level == 0 {
            return "BUILD"
        } else if canUpgrade {
            return "UPGRADE"
        } else {
            return "MAX LEVEL"
        }
    }
    
    mutating func upgrade() {
        if canUpgrade {
            level += 1
        }
    }
    
    static func defaultBuildings() -> [BuildingType] {
        return [
            BuildingType(
                id: "boilerroom",
                name: "Boiler room",
                description: "Speeds up room cleaning",
                imageName: "boilerroom",
                level: 0
            ),
            BuildingType(
                id: "garden",
                name: "Garden",
                description: "Speeds up food preparation",
                imageName: "garden",
                level: 0
            ),
            BuildingType(
                id: "library",
                name: "Library",
                description: "Increases customer satisfaction, which in turn affects the amount of tips received.",
                imageName: "library",
                level: 0
            ),
            BuildingType(
                id: "warehouse",
                name: "Warehouse",
                description: "Increases the maximum guest waiting time",
                imageName: "warehouse",
                level: 0
            )
        ]
    }
}
