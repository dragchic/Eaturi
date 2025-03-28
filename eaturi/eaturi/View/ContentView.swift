import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @State private var cartItems: [UUID: Int] = [:]
    @State private var isCartVisible = false
    @State private var isCategoryReached = false
    @State var categoryModels = CategoryModel.generateCategories()
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
        FoodModel(name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: 25000, calories: 200, protein: 30, carbs: 10, fiber: 30, fat: 10, isPopular: false, categories: ["Ayam", "Asam Manis"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
        FoodModel(name: "Nasi Goreng", image: "ayam_asam_manis", price: 20000, calories: 300, protein: 20, carbs: 50, fiber: 5, fat: 15, isPopular: true, categories: ["Nasi"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
        FoodModel(name: "Mie Goreng", image: "mie_goreng", price: 18000, calories: 350, protein: 25, carbs: 60, fiber: 7, fat: 12, isPopular: true, categories: ["Mie"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
        FoodModel(name: "Telur Balado", image: "telur_balado", price: 15000, calories: 250, protein: 15, carbs: 5, fiber: 3, fat: 8, isPopular: true, categories: ["Telur"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
        FoodModel(name: "Mie Goreng", image: "ayam_asam_manis", price: 18000, calories: 350, protein: 25, carbs: 60, fiber: 7, fat: 12, isPopular: false, categories: ["Mie"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
        FoodModel(name: "Telur Balado", image: "telur_balado", price: 15000, calories: 250, protein: 15, carbs: 5, fiber: 3, fat: 8, isPopular: true, categories: ["Telur"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal.")
    ]
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("colorSecondary"), location: 0.0),
                        .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                        .init(color: .white, location: 0.6)
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header with title and search bar
                    VStack(alignment: .leading) {
                        Text("Let's Start a")
                            .font(.largeTitle)
                            .foregroundColor(Color("BlackGray"))
                            .fontWeight(.bold)
                            .padding(.leading, 30)
                        HStack (spacing:0){
                            Text("Healthy")
                                .font(.largeTitle)
                                .foregroundColor(Color("colorPrimary"))
                                .fontWeight(.bold)
                                .padding(.leading, 30)
                            Text("Lifestyle")
                                .font(.largeTitle)
                                .foregroundColor(Color("BlackGray"))
                                .fontWeight(.bold)
                                .padding(.leading, 10)
                        }
                        
                        // Search bar with filter button
                        SearchBar(searchText: $searchText,
                                  isFilterModalPresented: $isFilterModalPresented,
                                  selectedFilters: $selectedFilters)
                    }
                    .padding(.top, 20)
                    
                    // Content ScrollView with CategoryView
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            CategoryView(searchText: $searchText,
                                         isCategoryReached: $isCategoryReached,
                                         categoryModels: $categoryModels,
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
