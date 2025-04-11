//
//  MenuView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MainBackView()
                
                VStack(spacing: 20) {
                    // Daily task
                    ActionView(name: .greenCapsule, text: "accommodate 5 guests", maxWidth: 300, maxHeight: 70)
                    
                    Spacer()
                    
                    NavigationLink {
                         GameView()
                    } label: {
                        ActionView(name: .mainRectangle, text: "start", maxWidth: 180, maxHeight: 55)
                    }

                    HStack(spacing: 10) {
                        NavigationLink {
                            // ProgressView()
                        } label: {
                            ActionView(name: .mainRectangle, text: "progress", maxWidth: 180, maxHeight: 55)
                        }
                        
                        NavigationLink {
                            // SettingsView()
                        } label: {
                            ActionView(name: .mainRectangle, text: "settings", maxWidth: 180, maxHeight: 55)
                        }
                        
                        NavigationLink {
                            // ShopView()
                        } label: {
                            ActionView(name: .mainRectangle, text: "shop", maxWidth: 180, maxHeight: 55)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    MenuView()
}
