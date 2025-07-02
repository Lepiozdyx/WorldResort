//
//  FarmView.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

struct FarmView: View {
    @Binding var appState: AppState
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            MainBackView(image: .farmbg)
            
            MenuCircleButtonView(appState: $appState)
            
            VStack {
                HStack {
                    Spacer()
                    CoinCounterView(amount: gameViewModel.coinBalance)
                }
                Spacer()
            }
            .padding(8)
            
            // Сетка 2 * 2 с BuildingButton, нажатие на кнопку открывает ZStack оверлей с BuildingDetailView()
            
            // ZStack оверлей с ManagerRepliesView() когда срабатывает триггер
        }
    }
}

#Preview {
    FarmView(appState: .constant(.farm))
        .environmentObject(GameViewModel())
}
