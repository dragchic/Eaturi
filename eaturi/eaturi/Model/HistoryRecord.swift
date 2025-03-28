//
//  HistoryModel.swift
//  eaturi
//
//  Created by Raphael Gregorius on 27/03/25.
//
import Foundation

struct HistoryRecord: Identifiable, Hashable, Encodable, Decodable {
    let id: UUID
    let date: Date
    let cart: [UUID: Int]
    var totalPrice: Int
    var totalCalories: Int
    var totalProtein: Int
    var totalCarbs: Int
    var totalFiber: Int
    var totalFat: Int
    
    // Initializer with food items
    init(
        id: UUID = UUID(),
        date: Date,
        cart: [UUID: Int],
        totalPrice: Int,
        totalCalories: Int,
        totalProtein: Int,
        totalCarbs: Int,
        totalFiber: Int,
        totalFat: Int
    ) {
        self.id = id
        self.date = date
        self.cart = cart
        self.totalPrice = totalPrice
        self.totalCalories = totalCalories
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFiber = totalFiber
        self.totalFat = totalFat
    }
}
