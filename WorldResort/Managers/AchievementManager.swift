//
//  AchievementManager.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import Foundation
import Combine

class AchievementManager: ObservableObject {
    static let shared = AchievementManager()
    
    private let userDefaultsKey = GameConstants.achievementKey
    
    @Published private(set) var achievements: [Achievement] = []
    
    private init() {
        loadAchievements()
        
        if achievements.isEmpty {
            resetAchievements()
        }
    }
    
    func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = savedAchievements
        }
    }
    
    private func saveAchievements() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func resetAchievements() {
        achievements = [
            Achievement(id: "first_day", title: "First Day at Work", description: "Check in your first guest", requirement: 1, progress: 0),
            Achievement(id: "manager_of_month", title: "Manager of the Month", description: "Check in 50 guests", requirement: 50, progress: 0),
            Achievement(id: "premium_service", title: "Premium Service", description: "Serve 100 guest requests", requirement: 100, progress: 0),
            Achievement(id: "comfort_guru", title: "Comfort Guru", description: "Check in 5 VIP guests", requirement: 5, progress: 0),
            Achievement(id: "profit_champion", title: "Profit Champion", description: "Earn 10,000 coins", requirement: 10000, progress: 0),
            Achievement(id: "cleanliness_success", title: "Cleanliness is Key", description: "Clean 50 rooms", requirement: 50, progress: 0),
            Achievement(id: "hospitality_service", title: "Hospitality Service", description: "Receive 20 tips from clients", requirement: 20, progress: 0),
            Achievement(id: "perfect_manager", title: "Perfect Manager", description: "Check in 5 guests without rejections", requirement: 5, progress: 0),
            Achievement(id: "speed_master", title: "Speed Master", description: "Check in 10 guests in 1 minute", requirement: 10, progress: 0),
            Achievement(id: "hotel_chain", title: "Hotel Chain", description: "Reach 100 check-ins", requirement: 100, progress: 0),
            Achievement(id: "customer_right", title: "Customer is Always Right", description: "Complete 50 food and cleaning orders", requirement: 50, progress: 0),
            Achievement(id: "opening_branch", title: "Opening a Branch", description: "Accumulate 50,000 coins", requirement: 50000, progress: 0),
            Achievement(id: "night_no_complaints", title: "Night Without Complaints", description: "Complete 10 levels in a row without clients leaving", requirement: 10, progress: 0),
            Achievement(id: "holiday_boom", title: "Holiday Boom", description: "Check in 20 guests", requirement: 20, progress: 0),
            Achievement(id: "luxury_king", title: "King of Luxury", description: "Fill all VIP rooms simultaneously", requirement: 2, progress: 0)
        ]
        saveAchievements()
    }
    
    // Методы для обновления достижений
    func updateGuestCheckedInCount(guestType: GuestType? = nil) {
        incrementAchievement(id: "first_day")
        incrementAchievement(id: "manager_of_month")
        incrementAchievement(id: "hotel_chain")
        incrementAchievement(id: "holiday_boom")
        
        if guestType == .vip {
            incrementAchievement(id: "comfort_guru")
        }
    }
    
    func updateServiceProvidedCount(service: ServiceType) {
        incrementAchievement(id: "premium_service")
        incrementAchievement(id: "customer_right")
        
        if service == .cleaning {
            incrementAchievement(id: "cleanliness_success")
        }
    }
    
    func updateCoinsEarned(amount: Int) {
        updateProgress(id: "profit_champion", currentTotal: amount)
        updateProgress(id: "opening_branch", currentTotal: amount)
    }
    
    func updateTipsReceived() {
        incrementAchievement(id: "hospitality_service")
    }
    
    func updatePerfectCheckIn() {
        incrementAchievement(id: "perfect_manager")
    }
    
    func checkSpeedMasterAchievement(guestsCheckedIn: Int, timeElapsed: TimeInterval) {
        if timeElapsed <= 60 && guestsCheckedIn >= 10 {
            completeAchievement(id: "speed_master")
        }
    }
    
    func checkLuxuryKingAchievement(filledLuxuryRooms: Int) {
        updateProgress(id: "luxury_king", currentValue: filledLuxuryRooms)
    }
    
    // Вспомогательные методы
    private func incrementAchievement(id: String) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            var achievement = achievements[index]
            if !achievement.isCompleted {
                achievement.progress += 1
                achievements[index] = achievement
                saveAchievements()
            }
        }
    }
    
    private func updateProgress(id: String, currentValue: Int) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            var achievement = achievements[index]
            if !achievement.isCompleted {
                achievement.progress = currentValue
                achievements[index] = achievement
                saveAchievements()
            }
        }
    }
    
    private func updateProgress(id: String, currentTotal: Int) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            var achievement = achievements[index]
            if !achievement.isCompleted {
                achievement.progress = currentTotal
                achievements[index] = achievement
                saveAchievements()
            }
        }
    }
    
    private func completeAchievement(id: String) {
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            var achievement = achievements[index]
            achievement.progress = achievement.requirement
            achievements[index] = achievement
            saveAchievements()
        }
    }
}
