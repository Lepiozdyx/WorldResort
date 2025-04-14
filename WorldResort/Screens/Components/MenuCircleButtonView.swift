//
//  MenuCircleButtonView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct MenuCircleButtonView: View {
    @Binding var appState: AppState
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    appState = .menu
                } label: {
                    Image(.brownCircle)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .overlay {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                }
                .soundButton()
                
                Spacer()
            }
            
            Spacer()
        }
        .padding([.horizontal, .top], 8)
    }
}

#Preview {
    MenuCircleButtonView(appState: .constant(.menu))
}
