//
//  TopBarView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct TopBarView: View {
    let amount: Int
    let pauseAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    pauseAction()
                } label: {
                    Image(.brownCircle)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .overlay {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(.white)
                        }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                CoinCounterView(amount: amount)
            }
            Spacer()
        }
        .padding([.horizontal, .top], 8)
    }
}

// MARK: - Previews
#Preview {
    TopBarView(amount: 130, pauseAction: {})
}
