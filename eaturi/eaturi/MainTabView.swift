//
//  MainTabView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var dummyCart: [UUID: Int] = [:]
    // Dummy cart data to pass as binding to HistoryView
//    @State private var dummyCart: [UUID: Int] = [
//        UUID(): 1,
//        UUID(): 2,
//        UUID(): 1
//    ]
    
//    var body: some View {
//        TabView {
//            ContentView()
//                .tabItem {
//                    Image(systemName: "fork.knife")
////                        .foregroundColor(Color("colorPrimary"))
//                    Text("Home")
//                }
//            
//            // Pass the binding to dummyCart into HistoryView
//            HistoryView(products: $dummyCart)
//                .tabItem {
//                    Image(systemName: "list.bullet.clipboard")
////                        .foregroundColor(Color("colorSecondary"))
//                    Text("History")
//                }
//        }
//        .tint(Color("colorPrimary"))
//    }
    
    var body: some View {
        VStack{
            ZStack{
                switch selectedTab {
                case 0:
                    ContentView()
                case 1:
                    HistoryView(products: $dummyCart)
                default:
                    EmptyView()
                }
            }
            HStack{
                Button{
                    selectedTab = 0
                } label: {
                    CustomTabBarItem(
                        icon: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == 0,
                        color: Color("colorPrimary")
                    )
                }
                Button{
                    selectedTab = 1
                } label: {
                    CustomTabBarItem(
                        icon: "list.bullet.clipboard",
                        title: "History",
                        isSelected: selectedTab == 1,
                        color: Color("colorPrimary")
                    )
                }
            }
            .frame(height: 85)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: -2)
        }
        .ignoresSafeArea(.all)
    }
}

struct CustomTabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing:5){
            Rectangle()
                .fill(isSelected ? color : Color.clear)
                .frame(height: 5)
                .cornerRadius(16)
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 25))
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
