//
//  RulesView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct RulesView: View {
    @Binding var appState: AppState
    @StateObject private var viewModel = RulesViewModel()
    
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
                            contentView
                        }
                        .tabViewStyle(.page)
                        .padding()
                    }
                    .overlay(alignment: .bottom) {
                        HStack(spacing: 20) {
                            Button {
                                viewModel.getPrevious()
                            } label: {
                                ActionView(name: .mainRectangle, text: "Prev", maxWidth: 140, maxHeight: 45)
                            }
                            .soundButton()
                            .opacity(viewModel.rule == .first ? 0 : 1)
                            
                            Button {
                                viewModel.getNext()
                            } label: {
                                ActionView(name: .mainRectangle, text: "Next", maxWidth: 140, maxHeight: 45)
                            }
                            .soundButton()
                            .opacity(viewModel.rule == .fifth ? 0 : 1)
                        }
                        .padding(.bottom)
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Content Views
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.rule {
        case .first:
            firstPage
        case .second:
            secondPage
        case .third:
            thirdPage
        case .fourth:
            fourthPage
        case .fifth:
            fifthPage
        }
    }
    
    private var firstPage: some View {
        VStack {
            Text("Rules")
                .font(.system(size: 40, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Serve the guests")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                    
                    Text("Guest may want food (blue marker on the key). Drag the bell to the room. After staying, the room becomes dirty (yellow marker). Clean it up by dragging the pipiduster.")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                VStack {
                    Image(.bell)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .offset(x: -20)
                    
                    Image(.cleaningBrush)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                }
            }
            
            Spacer()
            Spacer()
        }
    }
    
    private var secondPage: some View {
        VStack {
            Text("Rules")
                .font(.system(size: 40, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Check in guests")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                    
                    Text("Guests approach the counter and show which room they want. Drag the key on the request cloud to check in the guest. Guests are: regular travellers, business guests, families and VIP guests.")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                Image(.youngCouple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            }
            
            Spacer()
            Spacer()
        }
    }
    
    private var thirdPage: some View {
        VStack {
            Text("Rules")
                .font(.system(size: 40, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Room system")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                    
                    Text("🛏️ Single - for one guest. \n🛏️🛏️ Double - for one or two guests. \n🏡 Family - for families. \n👑 Luxury Suite - for VIP guests only.")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                Image(.keys)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
            }
            
            Spacer()
            Spacer()
        }
    }
    
    private var fourthPage: some View {
        VStack {
            Text("Rules")
                .font(.system(size: 40, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("What can go wrong?")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                    
                    Text("No rooms available - guest waits 15 sec and leaves. Wrong number - guest refuses and waits for a new offer. Waiting too long - guest loses patience and leaves.")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "face.smiling")
                        .frame(width: 100)
                        .offset(x: -25)
                        .foregroundStyle(.green)
                    
                    Image(systemName: "face.smiling")
                        .frame(width: 100)
                        .offset(x: -15)
                        .foregroundStyle(.yellow)
                    
                    Image(systemName: "face.smiling")
                        .frame(width: 100)
                        .foregroundStyle(.red)
                }
                .font(.system(size: 32))
            }
            
            Spacer()
            Spacer()
        }
    }
    
    private var fifthPage: some View {
        VStack {
            Text("Rules")
                .font(.system(size: 40, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Bonuses")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                    
                    Text("💰 Checked your guest in quickly and in the right room? Get a tip! \n📌 The main goal is to check-in guests, manage rooms and earn coins! 🚀🏨")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                Image(.sheikh)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    RulesView(appState: .constant(.rules))
}
