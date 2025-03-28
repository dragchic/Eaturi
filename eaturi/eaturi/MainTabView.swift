import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var historyManager = HistoryManager.shared
    @State private var cartItems: [UUID: Int] = [:]
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedTab {
                case 0:
                    ContentView(cartItems: $cartItems)
                        .environmentObject(historyManager)
                case 1:
                    HistoryView(historyRecords: $historyManager.historyRecords)
                default:
                    EmptyView()
                }
            }
            // Rest of your tab bar code remains the same
            HStack {
                Button {
                    selectedTab = 0
                } label: {
                    CustomTabBarItem(
                        icon: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == 0,
                        color: Color("colorPrimary")
                    )
                }
                Button {
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
            .frame(height: 90)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: -2)
        }
        .ignoresSafeArea(.all)
    }
}

// CustomTabBarItem remains unchanged

struct CustomTabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
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
                .foregroundColor(isSelected ? color : .gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainTabView()
}
