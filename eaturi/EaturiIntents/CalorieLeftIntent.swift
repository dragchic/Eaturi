//
//  CalorieLeftIntent.swift
//  eaturi
//
//  Created by Grachia Uliari on 21/05/25.
//

import AppIntents

struct RemainingCaloriesIntent: AppIntent, ProvidesDialog  {
    var value: Never?
    
    static var title: LocalizedStringResource = "Check Calorie Left"
    static var description = IntentDescription("Tell me how many calories I have left today.")
    
    static var suggestedInvocationPhrase: String? {
            "How many calories do I have left today?"
        }
    
    func perform() async throws -> some IntentResult & ProvidesDialog{
        let defaults = UserDefaults(suiteName: SharedDefaultsManager.suiteName)
        let tdee = defaults?.double(forKey: "TDEE") ?? 0
        let consumed = Double(defaults?.integer(forKey: "caloriesConsumed") ?? 0)
        let burned = defaults?.double(forKey: "caloriesBurned") ?? 0
        let remaining = max(0, Int(tdee - consumed + burned))
        
//        let answer = "You have \(remaining) kilocalories left today"
//        return .result(dialog: IntentDialog(speakableStringLiteral: answer))
        return .result(dialog: "You have \(remaining) kilocalories left today")

    }
}
