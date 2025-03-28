import SwiftUI

struct CategoryView: View {
    @Binding var searchText: String
    @Binding var isCategoryReached: Bool
    @Binding var categoryModels: [CategoryModel]
    @Binding var foodItems: [FoodModel]
    @Binding var selectedFilters: [String]
    @Binding var selectedFoodItem: FoodModel?
    @Binding var showDetailModal: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    var filteredFoodItems: [FoodModel] {
        var items = foodItems
        
        if !searchText.isEmpty {
            items = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        let nutritionalFilters = ["Low Carb", "Low Calorie", "High Protein", "Low Fat", "High Fiber"]
        
        let selectedNutritionalFilters = selectedFilters.filter { nutritionalFilters.contains($0) }
        let availableCategories = Set(foodItems.flatMap { $0.categories })
        let selectedCategoryFilters = selectedFilters.filter { availableCategories.contains($0) }
        
        if !selectedFilters.isEmpty && selectedCategoryFilters.isEmpty {
            return []
        }
        
        if !selectedNutritionalFilters.isEmpty {
            items = items.filter { item in
                var match = true
                if selectedNutritionalFilters.contains("Low Carb") && !(item.carbs < 20) {
                    match = false
                }
                if selectedNutritionalFilters.contains("Low Calorie") && !(item.calories < 250) {
                    match = false
                }
                if selectedNutritionalFilters.contains("High Protein") && !(item.protein > 20) {
                    match = false
                }
                if selectedNutritionalFilters.contains("Low Fat") && !(item.fat < 10) {
                    match = false
                }
                if selectedNutritionalFilters.contains("High Fiber") && !(item.fiber > 5) {
                    match = false
                }
                return match
            }
        }
        
        if !selectedCategoryFilters.isEmpty {
            items = items.filter { item in
                !Set(item.categories).intersection(selectedCategoryFilters).isEmpty
            }
        }
        
        return items
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if searchText.isEmpty {
                Text("Popular")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(popularMenus, id: \.id) { item in
                            PopularCardView(item: .constant(item))
                                .padding()
                                .frame(width: 230, height: 90)
                                .background(Color.white)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedFoodItem = item
                                    showDetailModal = true
                                }
                        }
                    }
                    .padding(.leading, 20)
                    .frame(maxHeight: 120)
                }
                .padding(.bottom, 12)
                
                VStack {
                    Text("Categories")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                }
                .frame(height: 30)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(categoryModels) { category in
                            VStack(spacing: 0) {
                                Image(category.image)
                                    .resizable()
                                    .frame(width: 52, height: 50)
                                    .cornerRadius(20)
                                Text(category.localName)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 80, height: 75)
                            .background(selectedFilters.contains(category.localName) ? Color("categorySelected").opacity(0.7) : Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selectedFilters.contains(category.localName) ? Color("Border") : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                withAnimation {
                                    if let index = selectedFilters.firstIndex(of: category.localName) {
                                        selectedFilters.remove(at: index)
                                    } else {
                                        selectedFilters.append(category.localName)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(height: 90)
                .padding(.bottom, 20)
                .shadow(radius: 2)
            } else {
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            
            if !searchText.isEmpty && filteredFoodItems.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No menu items found for \"\(searchText)\"")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("Try a different search term or clear the search field")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 17) {
                        ForEach(filteredFoodItems) { item in
                            VStack(alignment: .leading, spacing: 3) {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(item.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .onTapGesture {
                                            selectedFoodItem = item
                                            showDetailModal = true
                                        }
                                    
                                    if let quantity = cartItems[item.id] {
                                        QuantityControl(
                                            quantity: .constant(quantity),
                                            onIncrement: {
                                                cartItems[item.id] = quantity + 1
                                            },
                                            onDecrement: {
                                                if quantity > 1 {
                                                    cartItems[item.id] = quantity - 1
                                                } else {
                                                    cartItems.removeValue(forKey: item.id)
                                                    if cartItems.isEmpty {
                                                        isCartVisible = false
                                                    }
                                                }
                                            }
                                        )
                                        .padding(4)
                                    } else {
                                        Button(action: {
                                            cartItems[item.id] = 1
                                            isCartVisible = true
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(10)
                                                .background(Color("colorPrimary"))
                                                .foregroundColor(.white)
                                                .clipShape(Circle())
                                                .padding(8)
                                        }
                                    }
                                }
                                
                                Text(item.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                
                                Text("Rp\(item.price)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                HStack{
                                    Image(systemName:"flame.fill")
                                        .foregroundStyle(.colorOren)
                                    Text("\(item.calories) kcal")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(width: 164)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .sheet(item: $selectedFoodItem) { item in
                    FoodDetailView(
                        item: item,
                        isPresented: $showDetailModal,
                        cartItems: $cartItems,
                        isCartVisible: $isCartVisible,
                        showDetailModal: $showDetailModal
                    )
                    .presentationDetents([.fraction(0.9)])
                    .presentationCornerRadius(40)
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(false)
                    .onChange(of: showDetailModal) { _, newValue in
                        if !newValue {
                            selectedFoodItem = nil
                        }
                    }
                }
            }
        }
    }
}
