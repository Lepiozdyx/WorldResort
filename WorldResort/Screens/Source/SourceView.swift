//
//  SourceView.swift
//  WorldResort
//
//  Created by Alex on 15.04.2025.
//

import SwiftUI

struct SourceView: View {
    @StateObject private var state = AppStateViewModel()
    
    var body: some View {
        Group {
            switch state.appState {
            case .stepOne:
                LoadingView()
            case .stepTwo:
                if let url = state.webManager.targetURL {
                    WebViewManager(url: url, webManager: state.webManager)
                        .onAppear {
                            OrientationManager.shared.unlockOrientation()
                        }
                } else {
                    WebViewManager(url: NetworkManager.initialURL, webManager: state.webManager)
                        .onAppear {
                            OrientationManager.shared.unlockOrientation()
                        }
                }
            case .finalStep:
                ContentView()
                    .onAppear {
                        OrientationManager.shared.lockLandscape()
                    }
            }
        }
        .onAppear {
            state.stateCheck()
        }
    }
}

#Preview {
    SourceView()
}
