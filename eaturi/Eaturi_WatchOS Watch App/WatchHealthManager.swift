////
////  WatchHealthManager.swift
////  eaturi
////
////  Created by Grachia Uliari on 15/05/25.
////
//
//import HealthKit
//
//class WatchHealthManager: ObservableObject {
//    let healthStore = HKHealthStore()
//    
//    func requestAuthorization() {
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("⚠️ Health data not available")
//            return
//        }
//
//        let readTypes: Set<HKObjectType> = [
//            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
//            HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
//            HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
//            HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
//            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
//            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
//            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
//        ]
//
//        let shareTypes: Set<HKSampleType> = [
//            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
//            HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
//            HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
//            HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
//            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
//            HKObjectType.quantityType(forIdentifier: .height)!
//        ]
//
//        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    print("✅ HealthKit authorization granted on watchOS")
//                } else if let error = error {
//                    print("❌ HealthKit authorization failed on watchOS: \(error.localizedDescription)")
//                } else {
//                    print("❌ HealthKit authorization failed without error on watchOS")
//                }
//            }
//        }
//    }
//}
