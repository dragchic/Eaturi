//
//  CartModel.swift
//  eaturi
//
//  Created by Raphael Gregorius on 27/03/25.
//

import Foundation

// Improved CartModel with more robust methods
struct CartModel {
    var id = UUID()
    var cartItems: [UUID: Int]
    
    // Method to add an item to the cart
    mutating func addItem(_ itemId: UUID, quantity: Int = 1) {
        cartItems[itemId, default: 0] += quantity
    }
    
    // Method to remove an item from the cart
    mutating func removeItem(_ itemId: UUID, quantity: Int = 1) {
        guard var currentQuantity = cartItems[itemId] else { return }
        
        currentQuantity -= quantity
        if currentQuantity <= 0 {
            cartItems.removeValue(forKey: itemId)
        } else {
            cartItems[itemId] = currentQuantity
        }
    }
    
    // Method to clear the entire cart
    mutating func clearCart() {
        cartItems.removeAll()
    }
}
