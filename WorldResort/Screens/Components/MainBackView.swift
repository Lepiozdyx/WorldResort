//
//  MainBackView.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

struct MainBackView: View {
    var image: ImageResource = .bg
    
    var body: some View {
        Image(image)
            .resizable()
            .ignoresSafeArea()
    }
}

#Preview {
    MainBackView()
}
