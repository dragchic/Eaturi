//
//  CategoryView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct CategoryView: View {
    @Binding var searchText: String
    @Binding var popularMenus: [PopularMenu]
    @Binding var isCategoryReached: Bool
    @Binding var categories: [String]
    @Binding var foodItems: [FoodItem]
    @Binding var selectedFilters: [String]
    // FIX: Remove the 'private' access control from this binding
    @Binding var selectedFoodItem: FoodItem?
    @Binding var showDetailModal: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredFoodItems: [FoodItem] {
        var items = foodItems
        
        if !searchText.isEmpty {
            items = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        if !selectedFilters.isEmpty {
            items = items.filter { item in
                var match = true
                
                if selectedFilters.contains("Low Carb") && !(Int(item.carbs.replacingOccurrences(of: "g", with: "")) ?? 0 < 20) {
                    match = false
                }
                if selectedFilters.contains("Low Calorie") && !(Int(item.calories) ?? 0 < 250) {
                    match = false
                }
                if selectedFilters.contains("High Protein") && !(Int(item.protein.replacingOccurrences(of: "g", with: "")) ?? 0 > 20) {
                    match = false
                }
                if selectedFilters.contains("Low Fat") && !(Int(item.fat.replacingOccurrences(of: "g", with: "")) ?? 0 < 10) {
                    match = false
                }
                if selectedFilters.contains("High Fiber") && !(Int(item.fiber.replacingOccurrences(of: "g", with: "")) ?? 0 > 5) {
                    match = false
                }
                
                return match
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
                        ForEach($popularMenus) { item in
                            HStack {
                                PopularCardView(item: item)
                            }
                            .padding()
                            .frame(width: 200, height: 100)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
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
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(Color.black)
                                .cornerRadius(20)
                                .onTapGesture {
                                    print("\(category) selected")
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
                .sheet(isPresented: $showDetailModal) {
                    if let item = selectedFoodItem {
                        FoodDetailView(item: item, isPresented: $showDetailModal)
                    }
                }
            }
        }
    }
}
