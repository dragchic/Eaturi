import SwiftUI
import SwiftData
import HealthKit

@main
struct eaturiApp: App {
    let sharedModelContainer: ModelContainer = createContainer()
    let healthManager = HealthManager()
    
    init() {
        healthManager.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(cartItems: [:])
        }
        .modelContainer(sharedModelContainer)
    }

    @MainActor
    static func createContainer() -> ModelContainer {
        let schema = Schema([
            HistoryRecord.self,
            FoodModel.self
        ])
        let configuration = ModelConfiguration("eaturiDatabase", schema: schema)

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            var foodFetchDescriptor = FetchDescriptor<FoodModel>()
            foodFetchDescriptor.fetchLimit = 1

            let existingFoodItems = try container.mainContext.fetch(foodFetchDescriptor)

            if existingFoodItems.isEmpty {
                print("FoodModel database is empty. Seeding sample data...")
                let itemsToSeed = sampleFoodData()
                for item in itemsToSeed {
                    container.mainContext.insert(item)
                }
                try? container.mainContext.save()
                print("FoodModel sample data seeded successfully.")
            } else {
                print("FoodModel database already contains data.")
            }

            return container

        } catch {
            fatalError("Failed to create or seed ModelContainer: \(error)")
        }
    }
}
