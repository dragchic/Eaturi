import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodModel.name) private var foodItems: [FoodModel]

    @State private var selectedTab = 0

    @State var cartItems: [UUID: Int]
    @State var isCartVisible: Bool = false

    var body: some View {
        VStack {
            ZStack {
                switch selectedTab {
                case 0:
                    ContentView(cartItems: $cartItems, isCartVisible: $isCartVisible, foodItems: .constant(foodItems))
                        .environment(\.modelContext, modelContext)

                case 1:
                    HistoryView(onPickAgain: { selectedCart in
                        cartItems = selectedCart
                        isCartVisible = true
                        selectedTab = 0
                    })
                        .environment(\.modelContext, modelContext)

                default:
                    EmptyView()
                }
            }
           HStack {
                 Button {
                     selectedTab = 0
                 } label: {
                     CustomTabBarItem(icon: "fork.knife", title: "Menu", isSelected: selectedTab == 0, color: Color("colorPrimary"))
                 }
                 Button {
                     selectedTab = 1
                 } label: {
                     CustomTabBarItem(icon: "list.bullet.clipboard", title: "History", isSelected: selectedTab == 1, color: Color("colorPrimary"))
                 }
             }
             .frame(height: 90)
             .background(Color.white)
             .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: -2)
        }
        .ignoresSafeArea(.all)
        .preferredColorScheme(.light)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
