//
//  ShopItem.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct ShopItem: Identifiable, Codable {
    let id: String
    let name: String
    let price: Int
    var isPurchased: Bool = false
    
    var image: ImageResource {
        switch id {
        case "call": return .call
        case "fern": return .fern
        case "ficus": return .ficus
        case "liberty": return .liberty
        case "oscar": return .oscar
        default: return .ficus
        }
    }
}
