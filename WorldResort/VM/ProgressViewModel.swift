//
//  ProgressViewModel.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import Foundation

class ProgressViewModel: ObservableObject {
    @Published var currentAchievementIndex: Int = 0
    @Published var achievements: [Achievement] = []
    
    private let achievementManager = AchievementManager.shared
    
    init() {
        loadAchievements()
    }
    
    func loadAchievements() {
        achievements = achievementManager.achievements
    }
    
    var currentAchievement: Achievement? {
        guard !achievements.isEmpty else { return nil }
        return achievements[currentAchievementIndex]
    }
    
    var isAtFirstAchievement: Bool {
        return currentAchievementIndex == 0
    }
    
    var isAtLastAchievement: Bool {
        return currentAchievementIndex == achievements.count - 1
    }
    
    func showNextAchievement() {
        guard currentAchievementIndex < achievements.count - 1 else { return }
        currentAchievementIndex += 1
    }
    
    func showPreviousAchievement() {
        guard currentAchievementIndex > 0 else { return }
        currentAchievementIndex -= 1
    }
}
