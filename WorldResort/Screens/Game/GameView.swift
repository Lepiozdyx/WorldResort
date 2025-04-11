//
//  GameView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack {
            MainBackView()
            
            TopBarView(amount: 999, pauseAction: {})
            
            // MARK: WishBar and Left bar
            HStack {
                // WishBar
                Image(.wishes)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .overlay {
                        // Guests wish
                        Text("Double plz!")
                            .font(.system(size: 18))
                            .foregroundStyle(.black)
                            .offset(y: -20)
                    }
                    .offset(x: 0, y: -50)
                
                Spacer()
                
                VStack {
                    ItemContainerView(name: "kitchen", item: .bell)
                    
                    ItemContainerView(name: "cleaning", item: .cleaningBrush)
                }
            }
            .padding(.horizontal, 8)
            
            VStack {
                Spacer()
                
                HStack {
                    VStack(spacing: 15) {
                        // Single rooms
                        VStack {
                            Text("single")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(0..<4) { _ in
                                    ItemCellView(item: .keys, isRoom: true)
                                }
                            }
                        }
                        
                        // family rooms
                        VStack {
                            Text("family")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(0..<2) { _ in
                                    ItemCellView(item: .keys, isRoom: true)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        // Double rooms
                        VStack {
                            Text("double")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(0..<4) { _ in
                                    ItemCellView(item: .keys, isRoom: true)
                                }
                            }
                        }
                        
                        // Luxury rooms
                        VStack {
                            Text("luxury")
                                .font(.system(size: 12, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                            
                            HStack {
                                ForEach(0..<2) { _ in
                                    ItemCellView(item: .keys, isRoom: true)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: 450)
                
                Spacer()
                Spacer()
                Spacer()
            }
            
            // MARK: Client
            VStack {
                Spacer()
                
                HStack {
                    Image(.youngCouple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .offset(x: -80, y: 180)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameView()
}
