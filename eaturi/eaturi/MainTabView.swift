import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodModel.name) private var foodItems: [FoodModel]
    
    @State private var selectedTab = 0
    @State var cartItems: [UUID: Int]
    @State var isCartVisible: Bool = false
    @State private var showSplash = false
    @State private var shouldNavigateToCart = false  // Add this state variable
    
    @StateObject var healthManager = HealthManager()
    @State private var showProfilePrompt = false
    @State private var showProfileView = false

    
    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else {
                NavigationStack {
                    VStack {
                        ZStack {
                            switch selectedTab {
                            case 0:
                                ContentView(
                                    cartItems: $cartItems,
                                    isCartVisible: $isCartVisible,
                                    foodItems: .constant(foodItems),
                                    selectedTab: $selectedTab,
                                    shouldNavigateToCart: $shouldNavigateToCart  // Pass this binding
                                )
                                .environment(\.modelContext, modelContext)
                                
                            case 1:
                                HistoryView(onPickAgain: { selectedCart in
                                    cartItems = selectedCart
                                    isCartVisible = true
                                    selectedTab = 0
                                    shouldNavigateToCart = true  // Set this to true
                                })
                                .environment(\.modelContext, modelContext)
                                
                            case 2:
                                NutritionIntake()
                                    .environmentObject(healthManager)

                                
                            default:
                                EmptyView()
                            }
                        }
                        HStack {
                            Button {
                                selectedTab = 2
                            } label: {
                                CustomTabBarItem(icon: "chart.pie", title: "Tracking", isSelected: selectedTab == 2, color: Color("colorPrimary"))
                            }
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
                        .padding(.bottom, 12)
                        .frame(height: 90)
                        .background(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -1)
                    }
                    .ignoresSafeArea(.all)
                    .preferredColorScheme(.light)
                    .navigationDestination(isPresented: $shouldNavigateToCart) {
                        CartView(
                            cartItems: $cartItems,
                            foodItems: foodItems,
                            selectedTab: $selectedTab
                        )
                    }
                    
                    .sheet(isPresented: $showProfilePrompt) {
                        ProfileView(healthManager: healthManager) {
                            // Callback: dismiss sheet and recalculate TDEE
                            showSplash = false
                            healthManager.fetchAllHealthData()
                            healthManager.calculateTDEE()
                        }
                    }

                }
                .ignoresSafeArea(.keyboard)
                .ignoresSafeArea(.container, edges: .top)
                
                .sheet(isPresented: $showProfileView) {
                    ProfileView(healthManager: healthManager) {
                        healthManager.fetchAllHealthData()
                        healthManager.calculateTDEE()
                    }
                }

            }
        }
        .onAppear{
            healthManager.requestAuthorization()
            healthManager.fetchAllHealthData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                withAnimation(.easeOut(duration: 0.2)){
                    showSplash = false
                }
            }
        }
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
