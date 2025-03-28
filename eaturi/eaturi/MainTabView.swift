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
//                        .foregroundColor(Color("colorPrimary"))
                    Text("Home")
                }
            
            // Pass the binding to dummyCart into HistoryView
            HistoryView(products: $dummyCart)
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
//                        .foregroundColor(Color("colorSecondary"))
                    Text("History")
                }
        }
        .tint(Color("colorPrimary"))
    }
}

struct CustomTabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        VStack{
            Rectangle()
                .fill(isSelected ? color : Color.clear)
                .frame(height: 3)
                .cornerRadius(16)
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(isSelected ? color : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? color: .gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainTabView()
}
