//
//  Bank.swift
//  WorldResort
//
//  Created by Alex on 11.04.2025.
//

import Foundation
import Combine

class BankModel {
    private let userDefaultsKey = "worldResort.coinBalance"
    private var _coinBalance: CurrentValueSubject<Int, Never>
    
    var coinBalance: AnyPublisher<Int, Never> {
        _coinBalance.eraseToAnyPublisher()
    }
    
    init() {
        let savedBalance = UserDefaults.standard.integer(forKey: userDefaultsKey)
        _coinBalance = CurrentValueSubject<Int, Never>(savedBalance)
    }
    
    var currentBalance: Int {
        _coinBalance.value
    }
    
    func addCoins(_ amount: Int) {
        _coinBalance.value += amount
        saveBalance()
    }
    
    func deductCoins(_ amount: Int) -> Bool {
        guard _coinBalance.value >= amount else { return false }
        
        _coinBalance.value -= amount
        saveBalance()
        return true
    }
    
    func resetBalance() {
        _coinBalance.value = 0
        saveBalance()
    }
    
    private func saveBalance() {
        UserDefaults.standard.set(_coinBalance.value, forKey: userDefaultsKey)
    }
}
