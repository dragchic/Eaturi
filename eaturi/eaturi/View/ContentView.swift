import SwiftUI

// INTERFACE

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isFilterModalPresented = false
    @State private var selectedFilters: [String] = []
    @State private var cartItems: [UUID: Int] = [:]
    @State private var isCartVisible = false
    @State private var isCategoryReached = false
    @State private var selectedFoodItem: FoodModel?
    @State private var showDetailModal = false
    
    var totalCalories: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            return total + ((Int(item?.calories ?? "0") ?? 0) * entry.value)
        }
    }
    
    var totalPrice: Int {
        cartItems.reduce(0) { total, entry in
            let item = foodItems.first { $0.id == entry.key }
            let price = Int(item?.price.replacingOccurrences(of: "Rp", with: "").replacingOccurrences(of: ".", with: "") ?? "0") ?? 0
            return total + (price * entry.value)
        }
    }
    @State var foodItems = [
        FoodModel(name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: "Rp25.000", calories: "200", protein: "30g", carbs: "10g", fiber: "30g", fat: "10g", isPopular: false, categories: ["Ayam", "Asam Manis"]),
        FoodModel(name: "Nasi Goreng", image: "ayam_asam_manis", price: "Rp20.000", calories: "300", protein: "20g", carbs: "50g", fiber: "5g", fat: "15g", isPopular: true, categories: ["Nasi"]),
        FoodModel(name: "Mie Goreng", image: "mie_goreng", price: "Rp18.000", calories: "350", protein: "25g", carbs: "60g", fiber: "7g", fat: "12g", isPopular: true, categories: ["Mie"]),
        FoodModel(name: "Telur Balado", image: "telur_balado", price: "Rp15.000", calories: "250", protein: "15g", carbs: "5g", fiber: "3g", fat: "8g", isPopular: true, categories: ["Telur"]),
        FoodModel(name: "Mie Goreng", image: "ayam_asam_manis", price: "Rp18.000", calories: "350", protein: "25g", carbs: "60g", fiber: "7g", fat: "12g",isPopular: false, categories: ["Mie"]),
        FoodModel(name: "Telur Balado", image: "telur_balado", price: "Rp15.000", calories: "250", protein: "15g", carbs: "5g", fiber: "3g", fat: "8g",isPopular: true, categories: ["Telur"])
    ]
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }

    
    var body: some View {
        ZStack {
            VStack {
                // Header Section with Title and Search Bar
                VStack(alignment: .leading) {
                    Text("Start a \nHealthy Lifestyle")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .padding(.leading, 30)
                    
                    // Search Bar with Filter Button
                    SearchBar(searchText: $searchText, isFilterModalPresented: $isFilterModalPresented, selectedFilters: $selectedFilters)
                }
                
                // Content ScrollView with CategoryView
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        // Here we call CategoryView.
                        // Note: We removed 'private' from selectedFoodItem binding in CategoryView.
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
            
            // Cart Popup Overlay
            if isCartVisible && !cartItems.isEmpty {
                VStack {
                    CartPopUp(totalCalories: totalCalories, totalPrice: totalPrice)
                        .padding(.top, 10)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
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
