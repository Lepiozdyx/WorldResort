//
//  SettingsView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var appState: AppState
    @StateObject private var manager = SettingsManager.shared
    
    var body: some View {
        ZStack {
            MainBackView()
            Color.black.opacity(0.6).ignoresSafeArea()
            
            MenuCircleButtonView(appState: $appState)
            
            ZStack {
                Image(.mainRectangle)
                    .resizable()
                    .frame(width: 500, height: 300)
                
                VStack(spacing: 20) {
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                    
                    SwitchButtonView(header: "Music", isON: manager.isMusicOn) {
                        manager.switchMusic()
                    }
                    
                    SwitchButtonView(header: "Sound", isON: manager.isSoundOn) {
                        manager.switchSound()
                    }
                    
                    Button {
                        appState = .rules
                    } label: {
                        ActionView(name: .mainRectangle, text: "Rules", maxWidth: 180, maxHeight: 55)
                    }
                    .soundButton()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsView(appState: .constant(.settings))
}
