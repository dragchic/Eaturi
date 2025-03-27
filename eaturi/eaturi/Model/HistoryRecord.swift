//
//  HistoryModel.swift
//  eaturi
//
//  Created by Raphael Gregorius on 27/03/25.
//
import Foundation

struct HistoryRecord: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let cart: [UUID: Int] // Now using UUID as the key
    
    // Computed property: Total Price
    var totalPrice: Int {
        // Here you would need a mechanism to look up the FoodModel details (e.g. price)
        // For simplicity, assume a function lookupPrice(for:) exists
        cart.reduce(0) { total, entry in
            total + (lookupPrice(for: entry.key) * entry.value)
        }
    }
    
    // Computed property: Total Calories
    var totalCalories: Int {
        // Similar lookup for calories
        cart.reduce(0) { total, entry in
            total + (lookupCalories(for: entry.key) * entry.value)
        }
    }
    
    // Optional: a computed description string
    var description: String {
        "Purchased on \(dateFormatted): \(totalPrice) Rupiah, \(totalCalories) kcal"
    }
    
    // Format the date as a string
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Dummy functions for lookup (you need to implement these based on your data management)
func lookupPrice(for id: UUID) -> Int {
    // Look up the price for the FoodModel with this id
    return 0
}

func lookupCalories(for id: UUID) -> Int {
    // Look up the calories for the FoodModel with this id
    return 0
}
