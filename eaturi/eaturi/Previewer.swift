import SwiftUI
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: HistoryRecord.self,
            configurations: config
        )
        
        let sampleRecord = HistoryRecord(
            cart: [UUID(): 2],
            totalPrice: 25000,
            totalCalories: 350,
            totalProtein: 30,
            totalCarbs: 25,
            totalFiber: 2,
            totalFat: 15
        )
        
        container.mainContext.insert(sampleRecord)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return HistoryView(onPickAgain: { _ in })
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
