// eaturiApp.swift
import SwiftUI
import SwiftData

@main
struct eaturiApp: App {
    // Use the shared container setup
    let sharedModelContainer: ModelContainer = createContainer()

    var body: some Scene {
        WindowGroup {
            // Pass the empty cartItems initially if MainTabView still uses @State for it
            MainTabView(cartItems: [:])
        }
        // Apply the pre-configured container to the scene
        .modelContainer(sharedModelContainer)
    }

    // Moved container creation and seeding logic here
    @MainActor // Ensures context access is safe
    static func createContainer() -> ModelContainer {
        // Define the schema including BOTH models
        let schema = Schema([
            HistoryRecord.self,
            FoodModel.self // <--- ADD FoodModel HERE
        ])
        // Configuration for the database file
        let configuration = ModelConfiguration("eaturiDatabase", schema: schema) // Give your DB a name

        do {
            // Create the container
            let container = try ModelContainer(for: schema, configurations: [configuration])

            // --- Check if FoodModel data needs seeding ---
            var foodFetchDescriptor = FetchDescriptor<FoodModel>()
            foodFetchDescriptor.fetchLimit = 1 // We only need one to know if it's populated

            let existingFoodItems = try container.mainContext.fetch(foodFetchDescriptor)

            if existingFoodItems.isEmpty {
                print("FoodModel database is empty. Seeding sample data...")
                // If no items exist, insert the sample data
                let itemsToSeed = sampleFoodData() // Use the global function
                for item in itemsToSeed {
                    container.mainContext.insert(item)
                }
                // Optional: Try saving explicitly after seeding
                try? container.mainContext.save()
                print("FoodModel sample data seeded successfully.")
            } else {
                print("FoodModel database already contains data.")
            }
            // --- End Seeding Check ---

            return container

        } catch {
            // Handle errors appropriately in a real app
            fatalError("Failed to create or seed ModelContainer: \(error)")
        }
    }
}
