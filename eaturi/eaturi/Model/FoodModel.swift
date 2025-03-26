import SwiftUI

struct FoodModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let image: String
    let price: String
    let calories: String
    let protein: String
    let carbs: String
    let fiber: String
    let fat: String
    let isPopular: Bool
    let categories: [String]
    
    var description: String {
        "\(name): \(calories) kcal, \(protein)g protein, \(carbs)g carbs, \(fat)g fat, \(fiber)g fiber."
    }
}

