//
//  HistoryModel.swift
//  eaturi
//
//  Created by Raphael Gregorius on 27/03/25.
//
import Foundation

struct HistoryRecord: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let cart: [UUID: Int]
    let foodItems: [FoodModel]
    
    // Total price computation using actual food items
    var totalPrice: Int {
        cart.reduce(0) { total, entry in
            if let foodItem = foodItems.first(where: { $0.id == entry.key }) {
                return total + (foodItem.price * entry.value)
            }
            return total
        }
    }
    
    // Total calories computation using actual food items
    var totalCalories: Int {
        cart.reduce(0) { total, entry in
            if let foodItem = foodItems.first(where: { $0.id == entry.key }) {
                return total + (foodItem.calories * entry.value)
            }
            return total
        }
    }
    
    // Formatted date description
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Descriptive history record
    var description: String {
        "Purchased on \(dateFormatted): \(totalPrice) Rupiah, \(totalCalories) kcal"
    }
    
    // Initializer with food items
    init(
        id: UUID = UUID(),
        date: Date,
        cart: [UUID: Int],
        foodItems: [FoodModel]
    ) {
        self.id = id
        self.date = date
        self.cart = cart
        self.foodItems = foodItems
    }
}
