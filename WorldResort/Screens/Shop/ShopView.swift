//
//  ShopView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct ShopView: View {
    @Binding var appState: AppState
    @StateObject private var shopManager = ShopManager.shared
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            MainBackView()
            Color.black.opacity(0.6).ignoresSafeArea()
            
            MenuCircleButtonView(appState: $appState)
            
            VStack {
                HStack {
                    Spacer()
                    CoinCounterView(amount: gameViewModel.coinBalance)
                }
                Spacer()
            }
            .padding()
            
            Image(.mainRectangle)
                .resizable()
                .frame(width: 500, height: 270)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(shopManager.items) { item in
                        ShopItemView(
                            item: item,
                            coinBalance: gameViewModel.coinBalance,
                            onPurchase: {
                                _ = shopManager.purchaseItem(id: item.id, gameViewModel: gameViewModel)
                            }
                        )
                    }
                }
                .padding(.leading)
            }
            .frame(width: 485, height: 285)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            shopManager.loadItems()
        }
    }
}

#Preview {
    ShopView(appState: .constant(.shop))
        .environmentObject(GameViewModel())
}
