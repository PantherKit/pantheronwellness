//
//  pantheronwellnessApp.swift
//  pantheronwellness
//
//  Created by Emiliano Montes on 13/11/25.
//

import SwiftUI

@main
struct PantherOnWellnessApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
        }
    }
}
