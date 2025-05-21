//
//  SharedDefaultsManager.swift
//  eaturi
//
//  Created by Grachia Uliari on 14/05/25.
//

import Foundation
import WatchConnectivity

import Foundation
import WatchConnectivity

struct SharedDefaultsManager {
    static let suiteName = "group.com.grachia.eaturi"
    static let key = "foodHighestList"

    struct FoodItem: Codable {
        let name: String
        let calories: Int
    }

    static func saveTopFoods(_ foods: [FoodItem]) {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            print("Failed to access UserDefaults for suite: \(suiteName)")
            return
        }

        do {
            let encoded = try JSONEncoder().encode(foods)
            defaults.set(encoded, forKey: key)
        } catch {
            print("Failed to encode topFoods: \(error.localizedDescription)")
            return
        }

        #if os(iOS)
        if WCSession.default.isReachable {
            let message = [
                "topFoods": foods.map { ["name": $0.name, "calories": $0.calories] }
            ]
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("❌ Failed to send message to Watch: \(error.localizedDescription)")
            }
            print("✅ Sent topFoods to Watch: \(foods.map { $0.name })")
        } else {
            print("⌛️ Watch is not reachable.")
        }
        #endif
    }

    static func fetchTopFoods() -> [FoodItem] {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: key) else {
            return []
        }

        return (try? JSONDecoder().decode([FoodItem].self, from: data)) ?? []
    }
}
