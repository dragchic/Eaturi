//
//  CartView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct CartView: View {
    var totalCalories: Int
    var totalPrice: Int
    @Binding var cartItems: [UUID: Int]
    @Binding var foodItems: [FoodModel]

    var body: some View {
        VStack {
            Text("Cart")
                .font(.largeTitle)
                .padding()
            
            Text("Total Calories: \(totalCalories)")
            Text("Total Price: Rp\(totalPrice)")
            
            List {
                ForEach(cartItems.compactMap { key, value -> FoodModel? in
                    foodItems.first(where: { $0.id == key })
                }, id: \.id) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        if let qty = cartItems[item.id] {
                            Text("x\(qty)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Your Cart")
    }
}

#Preview {
    MainTabView()
}
