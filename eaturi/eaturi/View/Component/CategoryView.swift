//
//  CategoryView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct CategoryView: View {
    @Binding var searchText: String
    @Binding var isCategoryReached: Bool
    @Binding var foodItems: [FoodModel]
    @Binding var selectedFilters: [String]
    @Binding var selectedFoodItem: FoodModel?
    @Binding var showDetailModal: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    
    var categories : [String] {
        Set(foodItems.flatMap(\.categories)).sorted()
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var popularMenus: [FoodModel] {
        foodItems.filter { $0.isPopular }
    }
    
    var filteredFoodItems: [FoodModel] {
        var items = foodItems
        
        // Filter by search text
        if !searchText.isEmpty {
            items = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // Define nutritional filter keywords
        let nutritionalFilters = ["Low Carb", "Low Calorie", "High Protein", "Low Fat", "High Fiber"]
        
        // Separate nutritional and category filters
        let selectedNutritionalFilters = selectedFilters.filter { nutritionalFilters.contains($0) }
        let availableCategories = Set(foodItems.flatMap { $0.categories })
        let selectedCategoryFilters = selectedFilters.filter { availableCategories.contains($0) }
        
        // Apply nutritional filters if any
        if !selectedNutritionalFilters.isEmpty {
            items = items.filter { item in
                var match = true
                if selectedNutritionalFilters.contains("Low Carb") && !(Int(item.carbs.replacingOccurrences(of: "g", with: "")) ?? 0 < 20) {
                    match = false
                }
                if selectedNutritionalFilters.contains("Low Calorie") && !(Int(item.calories) ?? 0 < 250) {
                    match = false
                }
                if selectedNutritionalFilters.contains("High Protein") && !(Int(item.protein.replacingOccurrences(of: "g", with: "")) ?? 0 > 20) {
                    match = false
                }
                if selectedNutritionalFilters.contains("Low Fat") && !(Int(item.fat.replacingOccurrences(of: "g", with: "")) ?? 0 < 10) {
                    match = false
                }
                if selectedNutritionalFilters.contains("High Fiber") && !(Int(item.fiber.replacingOccurrences(of: "g", with: "")) ?? 0 > 5) {
                    match = false
                }
                return match
            }
        }
        
        // Apply category filters if any
        if !selectedCategoryFilters.isEmpty {
            items = items.filter { item in
                // Keep item if at least one of its categories matches a selected category
                !Set(item.categories).intersection(selectedCategoryFilters).isEmpty
            }
        }
        
        return items
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // If searchText is empty, display the popular menus and categories
            if searchText.isEmpty {
                Text("Popular")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(popularMenus, id: \.id) { item in
                            PopularCardView(item: .constant(item))
                                .padding()
                                .frame(width: 200, height: 100)
                                .background(Color.gray.opacity(0.1))
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
                
                
                GeometryReader { geometry in
                    VStack {
                        Text("Category")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.leading, 20)
                            .onAppear {
                                if geometry.frame(in: .global).minY <= 200 {
                                    withAnimation {
                                        isCategoryReached = true
                                    }
                                }
                            }
                    }
                }
                .frame(height: 30)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(selectedFilters.contains(category) ? Color.colorSecondary : Color.gray.opacity(0.1))
                                .foregroundColor(Color.black)
                                .cornerRadius(20)
                                .onTapGesture {
                                    if let index = selectedFilters.firstIndex(of: category) {
                                        selectedFilters.remove(at: index)
                                    } else {
                                        selectedFilters.append(category)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(height: 70)
            } else {
                // Show search results header if searchText is not empty
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            
            // If there are no results for the search text, show a friendly message
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
                // Show the food grid (filtered items) when there are results
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
                                        HStack(spacing: 5) {
                                            Button(action: {
                                                if quantity > 1 {
                                                    cartItems[item.id] = quantity - 1
                                                } else {
                                                    cartItems.removeValue(forKey: item.id)
                                                    if cartItems.isEmpty {
                                                        isCartVisible = false
                                                    }
                                                }
                                            }) {
                                                Image(systemName: "minus")
                                                    .padding(6)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                            }
                                            
                                            Text("\(quantity)")
                                                .font(.headline)
                                            
                                            Button(action: {
                                                cartItems[item.id] = quantity + 1
                                            }) {
                                                Image(systemName: "plus")
                                                    .padding(6)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                                            }
                                        }
                                        .padding(4)
                                        .background(Color.white)
                                        .cornerRadius(30)
                                        .padding(4)
                                    } else {
                                        Button(action: {
                                            cartItems[item.id] = 1
                                            isCartVisible = true
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(10)
                                                .background(Color.blue)
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
                                
                                Text(item.price)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Calories: \(item.calories)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                            .frame(width: 164)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .sheet(item: $selectedFoodItem) { item in
                    FoodDetailView(item: item, isPresented: $showDetailModal)
                        .presentationDetents([.fraction(0.9)])
                        .presentationCornerRadius(40)
                        .presentationDragIndicator(.visible)
                }
                
            }
        }
    }
}

#Preview {
    MainTabView()
}
