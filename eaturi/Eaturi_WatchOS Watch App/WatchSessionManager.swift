//
//  WatchSessionManager.swift
//  eaturi
//
//  Created by Grachia Uliari on 15/05/25.
//


import Foundation
import WatchConnectivity

class WatchSessionDelegate: NSObject, WCSessionDelegate, ObservableObject {
    @Published var topFoods: [SharedDefaultsManager.FoodItem] = []
    
    @Published var dailyCaloriesIntake: Int = 0
    @Published var dailyProtein: Double = 0
    @Published var dailyFat: Double = 0
    @Published var dailyCarbs: Double = 0
    @Published var dailyCaloriesBurned: Double = 0
    @Published var TDEE: Double = 0

    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("✅ Watch session activated: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let items = message["topFoods"] as? [[String: Any]] {
                let mapped = items.compactMap { dict in
                    if let name = dict["name"] as? String, let calories = dict["calories"] as? Int {
                        return SharedDefaultsManager.FoodItem(name: name, calories: calories)
                    }
                    return nil
                }
                self.topFoods = mapped
                print("✅ Updated topFoods: \(mapped.map { $0.name })")
            }

            if let intake = message["dailyCaloriesIntake"] as? Int {
                self.dailyCaloriesIntake = intake
            }
            if let protein = message["dailyProtein"] as? Double {
                self.dailyProtein = protein
            }
            if let fat = message["dailyFat"] as? Double {
                self.dailyFat = fat
            }
            if let carbs = message["dailyCarbs"] as? Double {
                self.dailyCarbs = carbs
            }
            if let burned = message["dailyCaloriesBurned"] as? Double {
                self.dailyCaloriesBurned = burned
            }
            if let tdee = message["TDEE"] as? Double {
                self.TDEE = tdee
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let items = applicationContext["topFoods"] as? [[String: Any]] {
                self.topFoods = items.compactMap { dict in
                    guard let name = dict["name"] as? String,
                          let calories = dict["calories"] as? Int else { return nil }
                    return SharedDefaultsManager.FoodItem(name: name, calories: calories)
                }
            }

            self.dailyCaloriesIntake = applicationContext["dailyCaloriesIntake"] as? Int ?? 0
            self.dailyProtein = applicationContext["dailyProtein"] as? Double ?? 0
            self.dailyFat = applicationContext["dailyFat"] as? Double ?? 0
            self.dailyCarbs = applicationContext["dailyCarbs"] as? Double ?? 0
            self.dailyCaloriesBurned = applicationContext["dailyCaloriesBurned"] as? Double ?? 0
            self.TDEE = applicationContext["TDEE"] as? Double ?? 0

            print("✅ Received applicationContext update")
        }
    }


}
