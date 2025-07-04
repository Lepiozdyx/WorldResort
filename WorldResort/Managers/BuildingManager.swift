//
//  BuildingManager.swift
//  WorldResort
//
//  Created by Alex on 03.07.2025.
//

import Foundation
import Combine

class BuildingManager: ObservableObject {
    static let shared = BuildingManager()
    
    private let userDefaultsKey = "buildingsKey"
    private let lastClaimKey = "lastBuildingClaimDate"
    
    @Published var buildings: [BuildingType] = []
    @Published var canClaimDailyReward = false
    @Published var dailyRewardAmount = 0
    
    private init() {
        loadBuildings()
        checkDailyReward()
    }
    
    func loadBuildings() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedBuildings = try? JSONDecoder().decode([BuildingType].self, from: data) {
            buildings = savedBuildings
        } else {
            resetBuildings()
        }
    }
    
    private func saveBuildings() {
        if let data = try? JSONEncoder().encode(buildings) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func resetBuildings() {
        buildings = BuildingType.defaultBuildings()
        saveBuildings()
    }
    
    // MARK: - Building Purchase Logic
    
    func canUpgradeBuilding(id: String, currentCoins: Int) -> Bool {
        guard let building = buildings.first(where: { $0.id == id }) else { return false }
        return building.canUpgrade && currentCoins >= building.upgradeCostCoins
    }
    
    func upgradeBuilding(id: String, gameViewModel: GameViewModel) -> Bool {
        guard let index = buildings.firstIndex(where: { $0.id == id }) else { return false }
        
        let building = buildings[index]
        guard building.canUpgrade else { return false }
        
        // Попытка списать монеты
        if gameViewModel.purchaseItem(price: building.upgradeCostCoins) {
            buildings[index].upgrade()
            saveBuildings()
            updateDailyReward()
            return true
        }
        
        return false
    }
    
    // MARK: - Daily Reward System
    
    private func checkDailyReward() {
        let lastClaimDate = UserDefaults.standard.object(forKey: lastClaimKey) as? Date ?? Date.distantPast
        let calendar = Calendar.current
        
        // Проверяем, прошло ли 24 часа с последнего сбора
        if calendar.date(byAdding: .hour, value: 24, to: lastClaimDate) ?? Date() <= Date() {
            canClaimDailyReward = true
            updateDailyReward()
        } else {
            canClaimDailyReward = false
            dailyRewardAmount = 0
        }
    }
    
    private func updateDailyReward() {
        dailyRewardAmount = buildings.reduce(0) { total, building in
            total + building.coinsPerDay
        }
        
        // Если есть доход и можно собрать награду
        if dailyRewardAmount > 0 && canClaimDailyReward {
            canClaimDailyReward = true
        } else if dailyRewardAmount == 0 {
            canClaimDailyReward = false
        }
    }
    
    func claimDailyReward(gameViewModel: GameViewModel) -> Bool {
        guard canClaimDailyReward && dailyRewardAmount > 0 else { return false }
        
        // Добавляем монеты в игровой банк
        gameViewModel.addCoinsFromBuildings(amount: dailyRewardAmount)
        
        // Обновляем дату последнего сбора
        UserDefaults.standard.set(Date(), forKey: lastClaimKey)
        
        // Сбрасываем возможность сбора до следующего дня
        canClaimDailyReward = false
        dailyRewardAmount = 0
        
        return true
    }
    
    // MARK: - Helper Methods
    
    func getBuilding(by id: String) -> BuildingType? {
        return buildings.first(where: { $0.id == id })
    }
    
    func hasAnyUpgradedBuildings() -> Bool {
        return buildings.contains { $0.level > 0 }
    }
    
    func getBuildingsByIds() -> [String: BuildingType] {
        var result: [String: BuildingType] = [:]
        for building in buildings {
            result[building.id] = building
        }
        return result
    }
    
    // Проверка на первое улучшение здания (для триггера реплик менеджера)
    func isBuildingFirstUpgrade(id: String) -> Bool {
        guard let building = buildings.first(where: { $0.id == id }) else { return false }
        return building.level == 1
    }
}
