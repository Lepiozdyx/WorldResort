//
//  ManagerRepliesView.swift
//  WorldResort
//
//  Created by Alex on 02.07.2025.
//

import SwiftUI

struct ManagerRepliesView: View {
    var body: some View {
        HStack {
            VStack {
                Spacer()
                
                Image(.wishes)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        // Тут отображаются все реплики мэнеджера в зависимости от триггера
                        Text("Our signature salad made with our carrots—and our customers are delighted!")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundStyle(.brownLight)
                            .multilineTextAlignment(.center)
                            .textCase(.uppercase)
                            .offset(y: -15)
                            .padding()
                    }
                    .offset(x: 100)
                
                Image(.manager)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea(edges: .bottom)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ManagerRepliesView()
}
