//
//  ShopManager.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

class ShopManager: ObservableObject {
    static let shared = ShopManager()
    
    private let userDefaultsKey = "shopItemsKey"
    
    @Published var items: [ShopItem] = []
    
    private init() {
        loadItems()
    }
    
    func loadItems() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedItems = try? JSONDecoder().decode([ShopItem].self, from: data) {
            items = savedItems
        } else {
            resetItems()
        }
    }
    
    private func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func resetItems() {
        items = [
            ShopItem(id: "call", name: "Call Bell", price: 900),
            ShopItem(id: "fern", name: "Fern Plant", price: 1750),
            ShopItem(id: "ficus", name: "Ficus Plant", price: 1750),
            ShopItem(id: "liberty", name: "Liberty Statue", price: 2500),
            ShopItem(id: "oscar", name: "Oscar Trophy", price: 5000)
        ]
        saveItems()
    }
    
    func purchaseItem(id: String, gameViewModel: GameViewModel) -> Bool {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return false }
        
        // Check if already purchased
        if items[index].isPurchased {
            return true
        }
        
        // Try to deduct coins
        if gameViewModel.purchaseItem(price: items[index].price) {
            items[index].isPurchased = true
            saveItems()
            
            // Update daily task
            DailyTaskManager.shared.shopPurchaseMade()
            
            return true
        }
        
        return false
    }
    
    func isPurchased(id: String) -> Bool {
        return items.first(where: { $0.id == id })?.isPurchased ?? false
    }
    
    func getPositionFor(item: ShopItem) -> CGPoint {
        // These positions can be adjusted based on design preferences
        switch item.id {
        case "call":
            return CGPoint(x: 100, y: 150)
        case "fern":
            return CGPoint(x: 200, y: 120)
        case "ficus":
            return CGPoint(x: 300, y: 140)
        case "liberty":
            return CGPoint(x: 400, y: 130)
        case "oscar":
            return CGPoint(x: 500, y: 160)
        default:
            return CGPoint(x: 250, y: 150)
        }
    }
}
