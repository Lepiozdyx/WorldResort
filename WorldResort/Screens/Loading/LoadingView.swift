//
//  LoadingView.swift
//  WorldResort
//
//  Created by Alex on 15.04.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            MainBackView()
            
            VStack {
                Spacer()
                
                Text("Loading...")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    .scaleEffect(isPulsing ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isPulsing)
                    .onAppear {
                        isPulsing = true
                    }
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    LoadingView()
}
