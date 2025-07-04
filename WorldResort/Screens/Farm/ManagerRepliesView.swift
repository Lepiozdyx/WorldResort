//
//  ManagerRepliesView.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

struct ManagerRepliesView: View {
    let replyText: String
    let isVisible: Bool
    
    @State private var bubbleScale: CGFloat = 0.8
    @State private var managerOffset: CGFloat = 100
    
    var body: some View {
        ZStack {
            if isVisible {
                HStack {
                    VStack {
                        speechBubbleView
                            .offset(x: 100)
                            .scaleEffect(bubbleScale)
                            .padding(.top)
                        
                        Image(.manager)
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea(edges: .bottom)
                            .offset(x: managerOffset)
                    }
                    
                    Spacer()
                }
                .onAppear {
                    animateAppearance()
                }
            }
        }
        .zIndex(1000)
    }
    
    private var speechBubbleView: some View {
        Image(.wishes)
            .resizable()
            .frame(maxWidth: 200, maxHeight: 150)
            .overlay {
                Text(replyText)
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(.brownLight)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
                    .shadow(color: .black, radius: 0.3, x: 0.5, y: 0.5)
                    .offset(y: -15)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
    }
    
    private func animateAppearance() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            managerOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                bubbleScale = 1.0
            }
        }
    }
}

#Preview {
    ManagerRepliesView(
        replyText: "Our signature salad made with our carrots—and our customers are delighted!",
        isVisible: true
    )
}
