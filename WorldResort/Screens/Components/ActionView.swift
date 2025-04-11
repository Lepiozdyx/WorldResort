//
//  ActionView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct ActionView: View {
    let name: ImageResource
    let text: String
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    var body: some View {
        Image(name)
            .resizable()
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .shadow(color: .black, radius: 2, x: 1, y: 1)
            .overlay {
                Text(text)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
            }
    }
}

#Preview {
    ActionView(name: .mainRectangle, text: "start", maxWidth: 200, maxHeight: 100)
}
