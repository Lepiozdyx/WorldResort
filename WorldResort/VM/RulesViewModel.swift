//
//  RulesViewModel.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

class RulesViewModel: ObservableObject {

    enum State: CaseIterable {
        case first
        case second
        case third
        case fourth
        case fifth
    }
    
    @Published var rule: State = .first

    func getNext() {
        guard let currentIndex = State.allCases.firstIndex(of: rule),
              currentIndex < State.allCases.count - 1 else {
            return
        }
        
        withAnimation {
            rule = State.allCases[currentIndex + 1]
        }
    }
    
    func getPrevious() {
        guard let currentIndex = State.allCases.firstIndex(of: rule),
              currentIndex > 0 else {
            return
        }
        
        withAnimation {
            rule = State.allCases[currentIndex - 1]
        }
    }
}
