//
//  WorldResortApp.swift
//  WorldResort
//
//  Created by Alex on 10.04.2025.
//

import SwiftUI

@main
struct WorldResortApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            SourceView()
                .preferredColorScheme(.light)
        }
    }
}
