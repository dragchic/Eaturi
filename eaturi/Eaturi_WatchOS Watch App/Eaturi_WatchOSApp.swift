//
//  Eaturi_WatchOSApp.swift
//  Eaturi_WatchOS Watch App
//
//  Created by Grachia Uliari on 12/05/25.
//

import SwiftUI

@main
struct Eaturi_WatchOS_Watch_AppApp: App {
    let healthManager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
        }
    }
}
