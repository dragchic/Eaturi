import Foundation
import SwiftUI

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    
    @Published var historyRecords: [HistoryRecord] = []
    
    private init() {
        // Load initial records when initialized
        historyRecords = loadHistoryRecords()
    }
    
    // Save to history with better state management
    func saveToHistory(
        cartItems: [UUID: Int],
        foodItems: [FoodModel],
        totalPrice: Int,
        totalCalories: Int,
        totalProtein: Int,
        totalCarbs: Int,
        totalFiber: Int,
        totalFat: Int,
        completion: (() -> Void)? = nil
    ) {
        let historyRecord = HistoryRecord(
            date: Date(),
            cart: cartItems,
            totalPrice: totalPrice,
            totalCalories: totalCalories,
            totalProtein: totalProtein,
            totalCarbs: totalCarbs,
            totalFiber: totalFiber,
            totalFat: totalFat
        )
        
        // Update both local state and persistent storage
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.historyRecords.append(historyRecord)
            self.saveHistoryRecords(self.historyRecords)
            completion?()
        }
    }
    
    // Private method to save records to UserDefaults
    private func saveHistoryRecords(_ records: [HistoryRecord]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(records)
            UserDefaults.standard.set(encodedData, forKey: "mealHistoryRecords")
        } catch {
            print("Error saving history records: \(error.localizedDescription)")
        }
    }
    
    // Private method to load records from UserDefaults
    private func loadHistoryRecords() -> [HistoryRecord] {
        guard let data = UserDefaults.standard.data(forKey: "mealHistoryRecords") else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([HistoryRecord].self, from: data)
        } catch {
            print("Error loading history records: \(error.localizedDescription)")
            return []
        }
    }
    
    // Retrieve history records (public access)
    func retrieveHistoryRecords() -> [HistoryRecord] {
        return historyRecords
    }
    
    // Delete a specific history record
    func deleteHistoryRecord(id: UUID) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.historyRecords.removeAll { $0.id == id }
            self.saveHistoryRecords(self.historyRecords)
        }
    }
    
    // Clear all history records
    func clearAllHistoryRecords() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.historyRecords.removeAll()
            UserDefaults.standard.removeObject(forKey: "mealHistoryRecords")
        }
    }
}
