//
//  CoinCounterView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct CoinCounterView: View {
    let amount: Int
    
    var body: some View {
        HStack(spacing: 2) {
            Image(.brownCircle)
                .resizable()
                .frame(width: 55, height: 55)
                .overlay {
                    Image(.coin)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            
            ActionView(name: .mainRectangle, text: "\(amount)", maxWidth: 100, maxHeight: 50)
        }
    }
}

#Preview {
    CoinCounterView(amount: 150)
}
