//
//  eaturiApp.swift
//  eaturi
//
//  Created by Raphael Gregorius on 20/03/25.
//

import SwiftUI
import SwiftData

@main
struct eaturiApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView(cartItems: [:])
                .modelContainer(
                    for: HistoryRecord.self,
                    isAutosaveEnabled: true
                )
        }
    }
}
