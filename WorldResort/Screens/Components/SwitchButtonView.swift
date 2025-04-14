//
//  SwitchButtonView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct SwitchButtonView: View {
    let header: String
    let isON: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(header)
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Spacer()
            
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Capsule()
                    .frame(width: 90, height: 50)
                    .foregroundStyle(isON ? .brownLight : .brownLight.opacity(0.7))
                    .overlay(alignment: isON ? .trailing : .leading) {
                        Capsule()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(isON ? .black.opacity(0.8) : .brown)
                            .padding(.horizontal, 6)
                    }
            }
            .soundButton()
            .buttonStyle(.plain)
        }
        .frame(width: 200)
    }
}

#Preview {
    SwitchButtonView(header: "sound", isON: true, action: {})
        .padding()
        .background(Color.gray)
}
