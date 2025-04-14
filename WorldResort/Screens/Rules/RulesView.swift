//
//  RulesView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct RulesView: View {
    @Binding var appState: AppState
    
    var body: some View {
        ZStack {
            MainBackView()
            Color.black.opacity(0.6).ignoresSafeArea()
            
            MenuCircleButtonView(appState: $appState)
            
            ZStack {
                Image(.mainRectangle)
                    .resizable()
                    .frame(width: 500, height: 300)
                    .overlay {
                        TabView {
                            // Content
                        }
                        .padding()
                    }
                    .overlay(alignment: .bottom) {
                        HStack(spacing: 20) {
                            Button {
                                // Previous page
                            } label: {
                                ActionView(name: .mainRectangle, text: "Prev", maxWidth: 140, maxHeight: 45)
                            }
                            .soundButton()
                            
                            Button {
                                // Next page
                            } label: {
                                ActionView(name: .mainRectangle, text: "Next", maxWidth: 140, maxHeight: 45)
                            }
                            .soundButton()
                        }
                        .padding(.bottom)
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RulesView(appState: .constant(.rules))
}
