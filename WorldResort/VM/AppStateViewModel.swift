//
//  AppStateViewModel.swift
//  WorldResort
//
//  Created by Alex on 15.04.2025.
//

import Foundation

@MainActor
final class AppStateViewModel: ObservableObject {
    
    enum AppState {
        case stepOne
        case stepTwo
        case finalStep
    }
    
    @Published private(set) var appState: AppState = .stepOne
    let webManager: NetworkManager
    
    private var timeoutTask: Task<Void, Never>?
    private let maxLoadingTime: TimeInterval = 10.0
    
    init(webManager: NetworkManager = NetworkManager()) {
        self.webManager = webManager
    }
    
    func stateCheck() {
        timeoutTask?.cancel()
        
        Task { @MainActor in
            do {
                if webManager.worldresortURL != nil {
                    updateState(.stepTwo)
                    return
                }
                
                let shouldShowWebView = try await webManager.checkInitialURL()
                
                if shouldShowWebView {
                    updateState(.stepTwo)
                } else {
                    updateState(.finalStep)
                }
                
            } catch {
                updateState(.finalStep)
            }
        }
        
        startTimeoutTask()
    }
    
    private func updateState(_ newState: AppState) {
        timeoutTask?.cancel()
        timeoutTask = nil
        
        appState = newState
    }
    
    private func startTimeoutTask() {
        timeoutTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: UInt64(maxLoadingTime * 1_000_000_000))
                
                if self.appState == .stepOne {
                    self.appState = .finalStep
                }
            } catch {}
        }
    }
    
    deinit {
        timeoutTask?.cancel()
    }
}

