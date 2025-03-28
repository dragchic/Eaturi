import SwiftUI

struct FoodModel: Identifiable {
    let id: UUID
    let name: String
    let image: String
    let price: Int
    let calories: Int
    let protein: Int
    let carbs: Int
    let fiber: Int
    let fat: Int
    let isPopular: Bool
    let categories: [String]
    let description: String

    static func sampleData() -> [FoodModel] {
        return [
            FoodModel(id: UUID(), name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: 25000, calories: 200, protein: 30, carbs: 10, fiber: 30, fat: 10, isPopular: false, categories: ["Ayam", "Asam Manis"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
            FoodModel(id: UUID(), name: "Nasi Goreng", image: "ayam_asam_manis", price: 20000, calories: 300, protein: 20, carbs: 50, fiber: 5, fat: 15, isPopular: true, categories: ["Nasi"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
            FoodModel(id: UUID(), name: "Mie Goreng", image: "mie_goreng", price: 18000, calories: 350, protein: 25, carbs: 60, fiber: 7, fat: 12, isPopular: true, categories: ["Mie"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
            FoodModel(id: UUID(), name: "Telur Balado", image: "telur_balado", price: 15000, calories: 250, protein: 15, carbs: 5, fiber: 3, fat: 8, isPopular: true, categories: ["Telur"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
            FoodModel(id: UUID(), name: "Mie Goreng", image: "ayam_asam_manis", price: 18000, calories: 350, protein: 25, carbs: 60, fiber: 7, fat: 12, isPopular: false, categories: ["Mie"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal."),
            FoodModel(id: UUID(), name: "Telur Balado", image: "telur_balado", price: 15000, calories: 250, protein: 15, carbs: 5, fiber: 3, fat: 8, isPopular: true, categories: ["Telur"], description: "Savor the irresistible flavor, a perfectly stir-fried noodle dish packed with savory spices, fresh vegetables, and tender proteins for a truly satisfying meal.")
        ]
    }
}
