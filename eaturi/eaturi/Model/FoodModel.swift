import SwiftUI

struct FoodModel: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var image: String
    var price: Int         // e.g. 25000
    var calories: Int      // e.g. 200
    var protein: Int       // e.g. 30
    var carbs: Int         // e.g. 10
    var fiber: Int         // e.g. 30
    var fat: Int           // e.g. 10
    var isPopular: Bool
    var categories: [String]
    
    // Example computed description (if needed)
    var description: String {
        "\(name): \(calories) kcal, \(protein)g protein, \(carbs)g carbs, \(fat)g fat, \(fiber)g fiber."
    }
}
