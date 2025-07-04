//
//  FarmViewModel.swift
//  WorldResort
//
//  Created by Alex on 03.07.2025.
//

import Foundation
import SwiftUI

class FarmViewModel: ObservableObject {
    @Published var selectedBuilding: BuildingType?
    @Published var showBuildingDetail = false
    
    // Система реплик менеджера
    @Published var showManagerReply = false
    @Published var currentManagerReply = ""
    @Published var hasShownWelcome = false
    
    private let buildingManager = BuildingManager.shared
    private let welcomeShownKey = "farmWelcomeShown"
    
    private var replyTimer: Timer?
    
    init() {
        hasShownWelcome = UserDefaults.standard.bool(forKey: welcomeShownKey)
    }
    
    // MARK: - Building Management
    
    func selectBuilding(_ building: BuildingType) {
        selectedBuilding = building
        withAnimation(.spring()) {
            showBuildingDetail = true
        }
    }
    
    func closeBuildingDetail() {
        withAnimation(.spring()) {
            showBuildingDetail = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.selectedBuilding = nil
        }
    }
    
    func upgradeSelectedBuilding(gameViewModel: GameViewModel) -> Bool {
        guard let building = selectedBuilding else { return false }
        
        let wasFirstUpgrade = building.level == 0
        let success = buildingManager.upgradeBuilding(id: building.id, gameViewModel: gameViewModel)
        
        if success {
            // Обновляем выбранное здание
            selectedBuilding = buildingManager.getBuilding(by: building.id)
            
            // Показываем реплику менеджера при первом улучшении
            if wasFirstUpgrade {
                showManagerReplyForBuilding(buildingId: building.id)
            }
        }
        
        return success
    }
    
    // MARK: - Daily Reward
    
    func claimDailyReward(gameViewModel: GameViewModel) -> Bool {
        let success = buildingManager.claimDailyReward(gameViewModel: gameViewModel)
        
        if success {
            showManagerReplyWithText("Excellent work! Your buildings are generating great profits!")
        }
        
        return success
    }
    
    // MARK: - Manager Replies System
    
    func showWelcomeMessageIfNeeded() {
        guard !hasShownWelcome else { return }
        
        hasShownWelcome = true
        UserDefaults.standard.set(true, forKey: welcomeShownKey)
        
        showManagerReplyWithText("Welcome to the Farm! Here you can build and upgrade facilities to generate passive income for your hotel.")
    }
    
    private func showManagerReplyForBuilding(buildingId: String) {
        guard let buildingType = Building(rawValue: buildingId) else { return }
        showManagerReplyWithText(buildingType.replies)
    }
    
    private func showManagerReplyWithText(_ text: String) {
        // Отменяем предыдущий таймер, если есть
        replyTimer?.invalidate()
        
        currentManagerReply = text
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showManagerReply = true
        }
        
        // Автоматически скрываем через 3 секунды
        replyTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                self?.showManagerReply = false
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func getBuildings() -> [BuildingType] {
        return buildingManager.buildings
    }
    
    func getBuildingById(_ id: String) -> BuildingType? {
        return buildingManager.getBuilding(by: id)
    }
    
    func canUpgradeBuilding(_ building: BuildingType, currentCoins: Int) -> Bool {
        return buildingManager.canUpgradeBuilding(id: building.id, currentCoins: currentCoins)
    }
    
    func getDailyRewardInfo() -> (canClaim: Bool, amount: Int) {
        return (buildingManager.canClaimDailyReward, buildingManager.dailyRewardAmount)
    }
    
    // Получение позиций для зданий в сетке 2x2
    func getBuildingGridPosition(for buildingId: String) -> (row: Int, column: Int) {
        switch buildingId {
        case "boilerroom": return (0, 0)
        case "garden": return (0, 1)
        case "library": return (1, 0)
        case "warehouse": return (1, 1)
        default: return (0, 0)
        }
    }
    
    deinit {
        replyTimer?.invalidate()
    }
}
