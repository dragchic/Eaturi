import SwiftUI
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: HistoryRecord.self, FoodModel.self,
            configurations: config
        )

        let sampleRecord = HistoryRecord(
            cart: [UUID(): 2],
            totalPrice: 25000, totalCalories: 350, totalProtein: 30,
            totalCarbs: 25, totalFiber: 2, totalFat: 15
        )
        container.mainContext.insert(sampleRecord)

         var foodFetchDescriptor = FetchDescriptor<FoodModel>()
         foodFetchDescriptor.fetchLimit = 1
         let existingFoodItems = try container.mainContext.fetch(foodFetchDescriptor)
         if existingFoodItems.isEmpty {
             print("Preview FoodModel container empty, seeding...")
             let sampleFoods = sampleFoodData()
             for food in sampleFoods {
                 container.mainContext.insert(food)
             }
             print("Preview FoodModel seeded.")
         }
    }
}

#Preview("Main Tab View") {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

#Preview("Main Tab View") {
    do {
        let previewer = try Previewer()
        
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
