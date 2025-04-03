// Previewer.swift (or wherever it's defined)
import SwiftUI
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        // Include BOTH models in the schema for the preview container
        container = try ModelContainer(
            for: HistoryRecord.self, FoodModel.self, // <--- ADD FoodModel here
            configurations: config
        )

        // --- Seed BOTH HistoryRecord and FoodModel for Preview ---

        // Seed HistoryRecord
        let sampleRecord = HistoryRecord(
            cart: [UUID(): 2], // Use a real UUID if possible, maybe from seeded food?
            totalPrice: 25000, totalCalories: 350, totalProtein: 30,
            totalCarbs: 25, totalFiber: 2, totalFat: 15
        )
        container.mainContext.insert(sampleRecord)

        // Seed FoodModel (only if empty for the preview container)
         var foodFetchDescriptor = FetchDescriptor<FoodModel>()
         foodFetchDescriptor.fetchLimit = 1
         let existingFoodItems = try container.mainContext.fetch(foodFetchDescriptor)
         if existingFoodItems.isEmpty {
             print("Preview FoodModel container empty, seeding...")
             let sampleFoods = sampleFoodData() // Use the global function
             for food in sampleFoods {
                 container.mainContext.insert(food)
             }
             print("Preview FoodModel seeded.")
         }
        // --- End Seeding ---
    }
}

// MainTabView Preview
#Preview("Main Tab View") { // Added a label for clarity
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:]) // Initialize with empty cart for preview
            .modelContainer(previewer.container) // Use the container from Previewer
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

#Preview("Main Tab View") {
    do {
        let previewer = try Previewer()
        
        // Initialize cartItems for preview, this is where you pass a sample cart state
        return MainTabView(cartItems: [:]) // Example with an empty cart
            .modelContainer(previewer.container) // Inject the preview container here
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
