import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var searchText = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    @State private var isCategoryReached = false
    @State var categoryModels = CategoryModel.generateCategories()
    @State private var selectedFoodItem: FoodModel?
    @State private var showDetailModal = false
    @State private var navigationPath = NavigationPath()
    @Binding var foodItems: [FoodModel]
    
    // MARK: - Computed Properties
    
    // Calculate nutritional totals
    private var nutritionTotals: (calories: Int, protein: Int, fat: Int, carbs: Int, fiber: Int, price: Int) {
        cartItems.reduce((0, 0, 0, 0, 0, 0)) { totals, entry in
            guard let item = foodItems.first(where: { $0.id == entry.key }) else {
                return totals
            }
            
            let quantity = entry.value
            return (
                totals.0 + (item.calories * quantity),
                totals.1 + (item.protein * quantity),
                totals.2 + (item.fat * quantity),
                totals.3 + (item.carbs * quantity),
                totals.4 + (item.fiber * quantity),
                totals.5 + (item.price * quantity)
            )
        }
    }
    
    var totalCalories: Int { nutritionTotals.calories }
    var totalProtein: Int { nutritionTotals.protein }
    var totalFat: Int { nutritionTotals.fat }
    var totalCarbs: Int { nutritionTotals.carbs }
    var totalFiber: Int { nutritionTotals.fiber }
    var totalPrice: Int { nutritionTotals.price }
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                backgroundGradient
                
                VStack {
                    headerSection
                    
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
                
                // Cart popup
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
//                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color("colorSecondary"), location: 0.0),
                .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                .init(color: Color("abubg"), location: 0.6)
            ]),
            startPoint: .topTrailing,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private var headerSection: some View {
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
            
            SearchBar(searchText: $searchText, isFilterModalPresented: $isFilterModalPresented, selectedFilters: $selectedFilters)
        }
        //                    .padding(.top, 20)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 60) // buat spasi aman untuk notch
        }
    }
}

// MARK: - Preference Key
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
