import SwiftUI

struct FoodModel: Identifiable, Hashable {
    let id: UUID
    var name: String
    var image: String
    var price: Int
    var calories: Int
    var protein: Int
    var carbs: Int
    var fiber: Int
    var fat: Int
    var isPopular: Bool
    var categories: [String]
    var description: String
    
    // Computed nutritional properties
    var nutritionalScore: Double {
        let proteinScore = Double(protein) * 4
        let carbScore = Double(carbs) * 4
        let fatScore = Double(fat) * 9
        return (proteinScore + carbScore + fatScore) / Double(calories)
    }
    
    // Descriptive nutritional information
    var nutritionalDescription: String {
        return "Protein: \(protein)g, Carbs: \(carbs)g, Fat: \(fat)g"
    }
    
    // Default initializer
    init(
        id: UUID = UUID(),
        name: String,
        image: String,
        price: Int,
        calories: Int,
        protein: Int,
        carbs: Int,
        fiber: Int,
        fat: Int,
        isPopular: Bool,
        categories: [String],
        description: String
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fiber = fiber
        self.fat = fat
        self.isPopular = isPopular
        self.categories = categories
        self.description = description
    }
}
