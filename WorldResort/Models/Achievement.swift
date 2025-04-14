//
//  Achievement.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let requirement: Int
    var progress: Int
    
    var isCompleted: Bool {
        return progress >= requirement
    }
}

enum ServiceType {
    case food
    case cleaning
}
