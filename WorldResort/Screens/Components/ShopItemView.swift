//
//  ShopItemView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct ShopItemView: View {
    let item: ShopItem
    let coinBalance: Int
    let onPurchase: () -> Void
    
    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text(item.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            if item.isPurchased {
                ActionView(name: .greenCapsule, text: "Purchased", maxWidth: 120, maxHeight: 35)
            } else {
                Button {
                    onPurchase()
                } label: {
                    ActionView(name: .mainRectangle, text: "\(item.price)", maxWidth: 120, maxHeight: 35)
                }
                .soundButton()
                .disabled(coinBalance < item.price)
                .opacity(coinBalance < item.price ? 0.5 : 1.0)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.5))
        )
    }
}

#Preview {
    ShopItemView(item: ShopItem.init(id: "ficus", name: "ficus", price: 500), coinBalance: 1500, onPurchase: {})
}
