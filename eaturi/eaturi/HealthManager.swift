//
//  HealthManager.swift
//  eaturi
//
//  Created by Grachia Uliari on 05/04/25.
//

import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        guard let energyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed),
              let proteinType = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
              let fatType = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal),
              let carbsType = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
              let fiberType = HKObjectType.quantityType(forIdentifier: .dietaryFiber) else {
            return
        }

        let typesToShare: Set = [energyType, proteinType, fatType, carbsType, fiberType]

        healthStore.requestAuthorization(toShare: typesToShare, read: []) { success, error in
            if success {
                print("HealthKit authorization success")
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }


    func saveNutrition(value: Double, unit: HKUnit, typeIdentifier: HKQuantityTypeIdentifier) {
        guard let type = HKObjectType.quantityType(forIdentifier: typeIdentifier) else { return }

        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let now = Date()

        let sample = HKQuantitySample(type: type, quantity: quantity, start: now, end: now)

        healthStore.save(sample) { success, error in
            if success {
                print("Saved \(typeIdentifier.rawValue): \(value)")
            } else {
                print("Error saving \(typeIdentifier.rawValue): \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
