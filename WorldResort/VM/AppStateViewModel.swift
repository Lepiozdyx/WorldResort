//
//  AppStateViewModel.swift
//  WorldResort
//
//  Created by Alex on 15.04.2025.
//

import Foundation

@MainActor
final class AppStateViewModel: ObservableObject {
    
    enum AppSteps {
        case stepOne
        case stepTwo
        case finalStep
    }
    
    @Published private(set) var appState: AppSteps = .stepOne
    let webManager: NetworkManager
    
    init(webManager: NetworkManager = NetworkManager()) {
        self.webManager = webManager
    }
    
    func stateCheck() {
        Task {
            if webManager.targetURL != nil {
                appState = .stepTwo
                return
            }
            
            do {
                if try await webManager.checkInitialURL() {
                    appState = .stepTwo
                } else {
                    appState = .finalStep
                }
            } catch {
                appState = .finalStep
            }
        }
    }
}
