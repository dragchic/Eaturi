import SwiftUI
import SwiftData

struct Previewer {
    let container: ModelContainer

    @MainActor
    init() throws {
        let schema = Schema([FoodModel.self, HistoryRecord.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: config)

        // Seed sample data for previews
        let context = container.mainContext
        let previewData = [
            FoodModel(
                name: "Ayam Teriyaki",
                image: "ayam_teriyaki",
                price: 25000,
                calories: 350,
                protein: 30,
                carbs: 25,
                fiber: 2,
                fat: 15,
                isPopular: true,
                categories: ["Ayam"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                foodDescription: "Lorem ipsum dolor sit amet..."
            ),
            FoodModel(
                name: "Ayam Bistik",
                image: "ayam_bistik",
                price: 27000,
                calories: 380,
                protein: 32,
                carbs: 20,
                fiber: 3,
                fat: 18,
                isPopular: true,
                categories: ["Ayam"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                foodDescription: "Ayam bistik saus jamur"
            )
        ]
        for item in previewData {
            context.insert(item)
        }
        try context.save()
    }
}
