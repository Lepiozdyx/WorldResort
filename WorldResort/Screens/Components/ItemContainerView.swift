//
//  ItemContainerView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct ItemContainerView: View {
    let name: String
    let item: ImageResource
    
    var body: some View {
        Image(.mainRectangle)
            .resizable()
            .frame(width: 120, height: 100)
            .shadow(color: .black, radius: 2, x: 1, y: 1)
            .overlay {
                VStack {
                    Text(name)
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                    
                    HStack {
                        ItemCellView(item: item)
                        
                        ItemCellView(item: item)
                    }
                }
            }
    }
}

struct ItemCellView: View {
    let item: ImageResource
    var isRoom = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 40, height: 50)
                .foregroundStyle(.brownLight)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green, lineWidth: 2)
                }
                .overlay {
                    // Drag gesture object
                    Image(item)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                }
            
            if isRoom {
                // Room number 101-101 - Single, 201-204 - Double, 301-302 - Family, 401-402 Luxury
                Text("101")
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    VStack {
        ItemContainerView(name: "Kitchen", item: .bell)
        ItemContainerView(name: "cleaning", item: .cleaningBrush)
    }
}
