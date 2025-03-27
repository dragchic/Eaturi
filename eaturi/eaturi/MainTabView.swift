//
//  MainTabView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct MainTabView: View {
    // Dummy cart data to pass as binding to HistoryView
    @State private var dummyCart: [UUID: Int] = [
        UUID(): 1,
        UUID(): 2,
        UUID(): 1
    ]
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Home")
                }
            
            // Pass the binding to dummyCart into HistoryView
            HistoryView(products: $dummyCart)
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("History")
                }
        }
    }
}

#Preview {
    MainTabView()
}
