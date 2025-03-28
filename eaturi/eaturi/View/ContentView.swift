import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    @State private var isCategoryReached = false
    @State var categoryModels = CategoryModel.generateCategories()
    @State private var selectedFoodItem: FoodModel?
    @State private var showDetailModal = false
    @State private var isCartViewActive = false
    @State private var navigationPath = NavigationPath()
    @Binding var foodItems: [FoodModel]
    var totalCalories: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.calories ?? 0) * entry.value)
        }
    }
    
    var totalProtein: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.protein ?? 0) * entry.value)
        }
    }
    
    var totalFat: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.fat ?? 0) * entry.value)
        }
    }
    
    var totalCarbs: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.carbs ?? 0) * entry.value)
        }
    }
    
    var totalFiber: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.fiber ?? 0) * entry.value)
        }
    }
    
    var totalPrice: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((item?.price ?? 0) * entry.value)
        }
    }
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                        
                        SearchBar(searchText: $searchText,
                                isFilterModalPresented: $isFilterModalPresented,
                                selectedFilters: $selectedFilters)
                    }
                    .padding(.top, 20)
                    
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
                
                if isCartVisible && !cartItems.isEmpty {
                    CartPopUp(cartItems: $cartItems, foodItems: $foodItems) {
                        navigationPath.append("cart")
                    }
                    .padding(.top, 10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "cart" {
                    CartView(
                        cartItems: $cartItems,
                        foodItems: foodItems
                    )
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
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
