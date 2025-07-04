//
//  GameViewModel.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import Foundation
import Combine
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var rooms: [RoomViewModel] = []
    @Published var currentGuest: Guest?
    @Published var isGamePaused = false
    @Published var coinBalance: Int = 0
    @Published var foodToolCooldown: TimeInterval = 0
    @Published var cleaningToolCooldown: TimeInterval = 0
    
    private var gameState = GameState()
    private var bank = BankModel()
    private let achievementManager = AchievementManager.shared
    private let dailyTaskManager = DailyTaskManager.shared
    
    private var newGuestTimer: AnyCancellable?
    private var timersCancellable = Set<AnyCancellable>()
    private var gameTimer: AnyCancellable?
    private var lastUpdateTime: Date = Date()
    
    // Переменные для отслеживания прогресса достижений
    private var consecutiveLevelsWithoutClientLeaving = 0
    private var guestsCheckedInCurrentMinute = 0
    private var guestCheckInTimeTracker: Date?
    private var perfectCheckInsInARow = 0
    
    init() {
        setupRooms()
        setupBank()
        startGameTimer()
    }
    
    private func setupRooms() {
        gameState.rooms.forEach { room in
            let roomViewModel = RoomViewModel(room: room, gameViewModel: self)
            // Обновляем обработчик выселения, чтобы он учитывал чаевые
            roomViewModel.didCheckoutGuest = { [weak self] guest, tips in
                self?.handleGuestCheckout(guest: guest, tips: tips)
            }
            roomViewModel.didCompleteCleaningRoom = { [weak self] roomVM in
                self?.handleRoomCleaningCompleted(roomVM: roomVM)
            }
            rooms.append(roomViewModel)
        }
    }
    
    private func setupBank() {
        bank.coinBalance
            .sink { [weak self] balance in
                self?.coinBalance = balance
                // Обновляем достижения связанные с монетами
                self?.achievementManager.updateCoinsEarned(amount: balance)
            }
            .store(in: &timersCancellable)
    }
    
    private func startGameTimer() {
        gameTimer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, !self.isGamePaused else { return }
                
                let now = Date()
                let deltaTime = now.timeIntervalSince(self.lastUpdateTime)
                self.lastUpdateTime = now
                
                self.updateTimers(deltaTime: deltaTime)
            }
    }
    
    private func updateTimers(deltaTime: TimeInterval) {
        // Обновление таймеров комнат
        rooms.forEach { $0.updateTimers(deltaTime: deltaTime) }
        
        // Обновление таймеров инструментов
        if foodToolCooldown > 0 {
            foodToolCooldown -= deltaTime
            if foodToolCooldown < 0 { foodToolCooldown = 0 }
        }
        
        if cleaningToolCooldown > 0 {
            cleaningToolCooldown -= deltaTime
            if cleaningToolCooldown < 0 { cleaningToolCooldown = 0 }
        }
        
        // Обновление таймера терпения гостя
        if let guest = currentGuest, !isGamePaused {
            var updatedGuest = guest
            updatedGuest.patienceTimeRemaining -= deltaTime
            
            if updatedGuest.patienceTimeRemaining <= 0 {
                // Гость ушел, не дождавшись
                updatedGuest.hasLeft = true
                currentGuest = updatedGuest
                handleGuestLeft()
            } else {
                currentGuest = updatedGuest
            }
        }
    }
    
    func startGame() {
        isGamePaused = false
        // Генерация первого гостя, если его еще нет
        if currentGuest == nil {
            generateNewGuest()
        }
    }
    
    func togglePause() {
        isGamePaused.toggle()
    }
    
    func resetGame() {
        isGamePaused = true
        
        // Сброс состояния игры
        gameState.resetGame()
        
        // Сброс всех вью моделей комнат
        rooms.forEach { $0.resetRoom() }
        
        // Удаление текущего гостя
        currentGuest = nil
        
        // Отмена таймеров
        newGuestTimer?.cancel()
        
        // Сброс кулдаунов инструментов
        foodToolCooldown = 0
        cleaningToolCooldown = 0
        
        // Сброс счетчиков для достижений
        consecutiveLevelsWithoutClientLeaving = 0
        guestsCheckedInCurrentMinute = 0
        guestCheckInTimeTracker = nil
        perfectCheckInsInARow = 0
    }
    
    func generateNewGuest() {
        // Отмена существующего таймера
        newGuestTimer?.cancel()
        
        // Создание нового случайного гостя
        let guestType = GuestType.randomType()
        let guest = Guest(type: guestType)
        
        // Установка текущего гостя
        currentGuest = guest
    }
    
    private func scheduleNextGuest() {
        newGuestTimer?.cancel()
        
        // Планирование следующего гостя после задержки
        newGuestTimer = Timer.publish(every: GameConstants.newGuestDelay, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                self?.generateNewGuest()
            }
    }
    
    func checkInGuest(to roomViewModel: RoomViewModel) -> Bool {
        guard let guest = currentGuest, !guest.hasLeft else { return false }
        
        // Отслеживание для достижения "Мастер скорости"
        if guestCheckInTimeTracker == nil {
            guestCheckInTimeTracker = Date()
            guestsCheckedInCurrentMinute = 0
        }
        
        // Проверка, прошла ли минута с первого заселения
        if let startTime = guestCheckInTimeTracker, Date().timeIntervalSince(startTime) > 60 {
            // Сброс счетчика для следующей минуты
            guestCheckInTimeTracker = Date()
            guestsCheckedInCurrentMinute = 0
        }
        
        // Проверка, может ли комната принять гостя
        if roomViewModel.canAccommodate(guest: guest) {
            // Заселение прошло успешно
            roomViewModel.checkInGuest(guest)
            currentGuest = nil
            scheduleNextGuest()
            
            // Отслеживание достижений
            achievementManager.updateGuestCheckedInCount(guestType: guest.type)
            
            // Обновляем прогресс ежедневного задания
            dailyTaskManager.guestAccommodated()
            
            // Отслеживание идеальных заселений (без отказов)
            perfectCheckInsInARow += 1
            if perfectCheckInsInARow >= 5 {
                achievementManager.updatePerfectCheckIn()
            }
            
            // Отслеживание достижения по скорости
            guestsCheckedInCurrentMinute += 1
            if let startTime = guestCheckInTimeTracker {
                let timeElapsed = Date().timeIntervalSince(startTime)
                achievementManager.checkSpeedMasterAchievement(
                    guestsCheckedIn: guestsCheckedInCurrentMinute,
                    timeElapsed: timeElapsed
                )
            }
            
            // Проверка достижения "Король люксов"
            let filledLuxuryRooms = rooms.filter {
                $0.roomType == .luxury && $0.status == .occupied
            }.count
            achievementManager.checkLuxuryKingAchievement(filledLuxuryRooms: filledLuxuryRooms)
            
            return true
        }
        
        // Заселение не удалось (неправильный тип комнаты)
        perfectCheckInsInARow = 0 // Сброс счетчика идеальных заселений
        return false
    }
    
    func handleGuestCheckout(guest: Guest, tips: Int = 0) {
        // Базовая награда за тип гостя
        let baseCoins = guest.type.coinReward
        // Добавляем чаевые к базовой награде
        let totalCoins = baseCoins + tips
        
        // Показываем анимацию или уведомление о полученных чаевых, если они есть
        if tips > 0 {
            // Тут можно добавить визуальное уведомление о чаевых
            print("Получены чаевые: \(tips) монет!")
            achievementManager.updateTipsReceived()
        }
        
        // Добавляем монеты в банк
        bank.addCoins(totalCoins)
        
        // Обновляем прогресс ежедневного задания
        dailyTaskManager.coinsCollected(amount: totalCoins)
        dailyTaskManager.clientKept()
    }
    
    func handleRoomCleaningCompleted(roomVM: RoomViewModel) {
        // Комната теперь доступна для новых гостей
    }
    
    func handleGuestLeft() {
        currentGuest = nil
        scheduleNextGuest()
        
        // Обновляем прогресс ежедневного задания
        dailyTaskManager.clientLost()
        
        // Сброс счетчика идеальных заселений при уходе гостя без обслуживания
        perfectCheckInsInARow = 0
        consecutiveLevelsWithoutClientLeaving = 0
    }
    
    func rooms(of type: RoomType) -> [RoomViewModel] {
        return rooms.filter { $0.roomType == type }
    }
    
    func serveFood(to roomViewModel: RoomViewModel) -> Bool {
        // Проверка, доступен ли инструмент (не на кулдауне)
        guard foodToolCooldown <= 0 else { return false }
        
        // Попытка подать еду
        let success = roomViewModel.serveFood()
        
        if success {
            // Запуск кулдауна
            foodToolCooldown = GameConstants.toolCooldownTime
            
            // Отслеживание достижения
            achievementManager.updateServiceProvidedCount(service: .food)
            
            // Обновляем прогресс ежедневного задания
            dailyTaskManager.serviceCompleted()
        }
        
        return success
    }
    
    func cleanRoom(roomViewModel: RoomViewModel) -> Bool {
        // Проверка, доступен ли инструмент (не на кулдауне)
        guard cleaningToolCooldown <= 0 else { return false }
        
        // Попытка очистить комнату
        let success = roomViewModel.cleanRoom()
        
        if success {
            // Запуск кулдауна
            cleaningToolCooldown = GameConstants.toolCooldownTime
            
            // Отслеживание достижения
            achievementManager.updateServiceProvidedCount(service: .cleaning)
            
            // Обновляем прогресс ежедневного задания
            dailyTaskManager.serviceCompleted()
        }
        
        return success
    }
    
    // Метод для получения награды за выполнение ежедневного задания
    func addCoinsFromDailyTask() -> Bool {
        if let reward = dailyTaskManager.claimReward() {
            bank.addCoins(reward)
            return true
        }
        return false
    }
    
    func purchaseItem(price: Int) -> Bool {
        return bank.deductCoins(price)
    }
    
    func addCoinsFromBuildings(amount: Int) {
        bank.addCoins(amount)
        dailyTaskManager.coinsCollected(amount: amount)
    }
}
