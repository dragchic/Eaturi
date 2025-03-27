import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @State private var cartItems: [UUID: Int] = [:]
    @State private var isCartVisible = false
    @State private var isCategoryReached = false
    @State private var selectedFoodItem: FoodModel?
    @State private var showDetailModal = false
    @State private var isCartViewActive = false  // Controls navigation to CartView

    var totalCalories: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.calories ?? 0) * entry.value)
        }
    }
    
    var totalPrice: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.price ?? 0) * entry.value)
        }
    }
    
    @State var foodItems: [FoodModel] = [
        FoodModel(name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: 25000, calories: 200, protein: 30, carbs: 10, fiber: 30, fat: 10, isPopular: false, categories: ["Ayam", "Asam Manis"]),
        FoodModel(name: "Nasi Goreng", image: "ayam_asam_manis", price: 20000, calories: 300, protein: 20, carbs: 50, fiber: 5, fat: 15, isPopular: true, categories: ["Nasi"]),
        FoodModel(name: "Mie Goreng", image: "mie_goreng", price: 18000, calories: 350, protein: 25, carbs: 60, fiber: 7, fat: 12, isPopular: true, categories: ["Mie"]),
        FoodModel(name: "Telur Balado", image: "telur_balado", price: 15000, calories: 250, protein: 15, carbs: 5, fiber: 3, fat: 8, isPopular: true, categories: ["Telur"]),
        FoodModel(name: "Mie Goreng", image: "ayam_asam_manis", price: 18000, calories: 350, protein: 25, carbs: 60, fiber: 7, fat: 12, isPopular: false, categories: ["Mie"]),
        FoodModel(name: "Telur Balado", image: "telur_balado", price: 15000, calories: 250, protein: 15, carbs: 5, fiber: 3, fat: 8, isPopular: true, categories: ["Telur"])
    ]
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Header with title and search bar
                    VStack(alignment: .leading) {
                        Text("Start a \nHealthy Lifestyle")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.leading, 30)
                        
                        // Search bar with filter button
                        SearchBar(searchText: $searchText,
                                  isFilterModalPresented: $isFilterModalPresented,
                                  selectedFilters: $selectedFilters)
                    }
                    
                    // Content ScrollView with CategoryView
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            CategoryView(searchText: $searchText,
                                         isCategoryReached: $isCategoryReached,
                                         foodItems: $foodItems,
                                         selectedFilters: $selectedFilters,
                                         selectedFoodItem: $selectedFoodItem,
                                         showDetailModal: $showDetailModal,
                                         cartItems: $cartItems,
                                         isCartVisible: $isCartVisible)
                        }
                    }
                }
                
                // NavigationLink for CartView (hidden)
                NavigationLink(destination: CartView(totalCalories: totalCalories, totalPrice: totalPrice, cartItems: $cartItems, foodItems: $foodItems),
                               isActive: $isCartViewActive,
                               label: {
                                   EmptyView()
                               })
                .hidden()
                
                // Cart popup overlay at bottom
                if isCartVisible && !cartItems.isEmpty {
                    CartPopUp(cartItems: $cartItems, foodItems: $foodItems) {
                        isCartViewActive = true  // Trigger navigation to CartView when tapped
                    }
                    .padding(.top, 10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
