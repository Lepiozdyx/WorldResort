//
//  DailyTaskManager.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import Foundation
import SwiftUI

class DailyTaskManager: ObservableObject {
    static let shared = DailyTaskManager()
    
    private let userDefaultsKey = GameConstants.dailyTaskKey
    
    @Published private(set) var currentTask: DailyTask?
    @Published private(set) var todayCoinsCollected: Int = 0
    
    private var clientsKept = 0
    private var hasLostClient = false
    
    private var timer: Timer?
    
    let completionReward = 500
    
    private init() {
        loadTask()
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) { [weak self] _ in
            self?.checkForExpiration()
        }
        
        checkForExpiration()
    }
    
    private func checkForExpiration() {
        guard let task = currentTask else {
            generateNewTask()
            return
        }
        
        if task.isExpired {
            generateNewTask()
        } else {
            objectWillChange.send()
        }
    }
    
    private func loadTask() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedTask = try? JSONDecoder().decode(DailyTask.self, from: data) {
            currentTask = savedTask
            
            // If the task has expired, generate a new one
            if savedTask.isExpired {
                generateNewTask()
            }
        } else {
            generateNewTask()
        }
    }
    
    private func saveTask() {
        if let task = currentTask, let data = try? JSONEncoder().encode(task) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func generateNewTask() {
        // Reset tracking variables
        todayCoinsCollected = 0
        clientsKept = 0
        hasLostClient = false
        
        // Create a new random task
        let taskType = DailyTask.TaskType.allCases.randomElement()!
        currentTask = DailyTask(type: taskType, creationDate: Date())
        
        saveTask()
    }
    
    // MARK: - Task progress methods
    
    func guestAccommodated() {
        updateTaskProgress(for: .accommodateGuests)
    }
    
    func serviceCompleted() {
        updateTaskProgress(for: .completeServices)
    }
    
    func shopPurchaseMade() {
        updateTaskProgress(for: .makeShopPurchase)
    }
    
    func clientKept() {
        clientsKept += 1
        updateTaskProgress(for: .keepClients)
    }
    
    func clientLost() {
        hasLostClient = true
    }
    
    func coinsCollected(amount: Int) {
        todayCoinsCollected += amount
        updateTaskProgress(for: .collectCoins, with: todayCoinsCollected)
    }
    
    func claimReward() -> Int? {
        guard var task = currentTask, task.isCompleted, !task.isRewardClaimed else { return nil }
        
        task.isRewardClaimed = true
        currentTask = task
        saveTask()
        
        return completionReward
    }
    
    private func updateTaskProgress(for taskType: DailyTask.TaskType, with value: Int? = nil) {
        guard var task = currentTask, task.type == taskType, !task.isCompleted else { return }
        
        if taskType == .keepClients && hasLostClient {
            return  // Can't complete this task if a client has been lost
        }
        
        // Increment progress or use provided value
        if let value = value {
            task.progress = value
        } else {
            task.progress += 1
        }
        
        // Check for task completion
        if task.progress >= task.type.requirement && !task.isCompleted {
            task.isCompleted = true
        }
        
        currentTask = task
        saveTask()
    }
    
    func formattedTimeRemaining() -> String {
        guard let task = currentTask else { return "24h" }
        
        let totalSeconds = max(0, Int(task.timeRemaining))
        let hours = totalSeconds / 3600
        
        return "\(hours)h"
    }
}
