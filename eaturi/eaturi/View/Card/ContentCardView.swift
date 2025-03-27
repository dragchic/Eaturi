//
//  ContentCardView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct ContentCardView: View {
    @Binding var item: FoodModel
    @Binding private var isCartVisible: Bool
    @State private var selectedFoodItem: FoodModel?
    @Binding private var showDetailModal: Bool
    @Binding private var cartItems: [UUID: Int]
    
    var body: some View {
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
                
                let quantity = cartItems[item.id] ?? 0
                
                if quantity > 0{
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
                                .overlay(Circle().stroke(Color("colorPrimary"), lineWidth: 1))
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

#Preview {
    MainTabView()
}
