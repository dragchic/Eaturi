//
//  HealthManager.swift
//  eaturi
//
//  Created by Grachia Uliari on 05/04/25.
//

import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    private var fetchTimer: Timer?

    
    @Published var dailyCaloriesBurned: Double = 0.0
    @Published var dailyCaloriesIntake: Int = 0
    @Published var dailyCarbs: Double = 0
    @Published var dailyProtein: Double = 0
    @Published var dailyFat: Double = 0
    
    @Published var biologicalSex: HKBiologicalSex?
    @Published var dateOfBirth: Date?
    @Published var height: Double?
    @Published var weight: Double?
    @Published var TDEE: Double?
    @Published var activityLevel: String = "moderate"
    
    var targetProtein: Double {
            let calories = TDEE ?? 0
            return (0.20 * calories) / 4
        }
        
        var targetFat: Double {
            let calories = TDEE ?? 0
            return (0.25 * calories) / 9
        }
        
        var targetCarbs: Double {
            let calories = TDEE ?? 0
            return (0.55 * calories) / 4
        }
    
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        guard let energyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed),
              let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              let proteinType = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
              let fatType = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal),
              let carbsType = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
              let fiberType = HKObjectType.quantityType(forIdentifier: .dietaryFiber),
              let heightType = HKObjectType.quantityType(forIdentifier: .height),
              let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex)else {
            return
        }
        
        let typesToRead: Set = [energyType, caloriesBurnedType, proteinType, fatType, carbsType, fiberType, heightType, weightType, biologicalSexType, dateOfBirthType]
        let typesToWrite: Set = [energyType, proteinType, fatType, carbsType, fiberType, heightType, weightType]
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            if success {
                print("HealthKit authorization success")
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAllHealthData() {
        getBiologicalSex()
        //        getMostRecentHeight()
        getHeight()
//        getMostRecentWeight()
        getWeight()
        getActiveEnergyBurnedToday()
        getDateOfBirth()
        getDietaryEnergyConsumedToday()
        getDailyProtein()
        getDailyFat()
        getDailyCarbs()
    }
    
    func fetchDailyData(for date: Date) {
        // Batalkan fetch sebelumnya
        fetchTimer?.invalidate()

        // Tunggu 0.3 detik sebelum fetch lagi
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.getActiveEnergyBurned(on: date)
            self.getDailyNutrition(for: date)
        }
    }

    
    private func getActiveEnergyBurned(on date: Date) {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.dailyCaloriesBurned = sum.doubleValue(for: .kilocalorie())
                    print("Burned on \(date): \(self.dailyCaloriesBurned) kcal")
                } else {
                    self.dailyCaloriesBurned = 0
                    print("No active energy data found on \(date)")
                }
            }
        }

        healthStore.execute(query)
    }

    
    private func getDailyNutrition(for date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)

        func fetch(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
            guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }

            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                DispatchQueue.main.async {
                    if let sum = result?.sumQuantity() {
                        completion(sum.doubleValue(for: unit))
                    } else {
                        completion(0)
                        print("No data for \(identifier.rawValue): \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }

            healthStore.execute(query)
        }

        fetch(.dietaryEnergyConsumed, unit: .kilocalorie()) { self.dailyCaloriesIntake = Int($0) }
        fetch(.dietaryProtein, unit: .gram()) { self.dailyProtein = $0 }
        fetch(.dietaryFatTotal, unit: .gram()) { self.dailyFat = $0 }
        fetch(.dietaryCarbohydrates, unit: .gram()) { self.dailyCarbs = $0 }
    }


    
    private func getBiologicalSex() {
        do {
            let sex = try healthStore.biologicalSex().biologicalSex
            DispatchQueue.main.async {
                self.biologicalSex = sex
            }
        } catch {
            print("Failed to read biological sex: \(error.localizedDescription)")
        }
    }
    
    func getHeight() {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else { return }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else {
                print("No height data found.")
                return
            }

            let heightInCm = sample.quantity.doubleValue(for: .meterUnit(with: .centi))
            DispatchQueue.main.async {
                self.height = heightInCm
                print("Most recent height: \(heightInCm) cm")
            }
        }

        healthStore.execute(query)
    }
    
    func getWeight() {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else {
                print("No height data found.")
                return
            }

            let weightInKg = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
            DispatchQueue.main.async {
                self.weight = weightInKg
                print("Most recent weight: \(weightInKg) kg")
            }
        }

        healthStore.execute(query)
    }
    
    func getDietaryEnergyConsumedToday() {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else { return }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.dailyCaloriesIntake = Int(sum.doubleValue(for: .kilocalorie()))
                    print("Fetched dietary energy consumed: \(self.dailyCaloriesIntake) kcal")
                } else {
                    print("No dietary energy data found or error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        healthStore.execute(query)
    }
    
    func getDailyProtein() {
        guard let proteinType = HKQuantityType.quantityType(forIdentifier: .dietaryProtein) else { return }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: proteinType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.dailyProtein = sum.doubleValue(for: .gram())
                    print("Fetched dietary protein consumed: \(self.dailyProtein) g")
                } else {
                    print("No dietary protein data found or error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        healthStore.execute(query)
    }
    
    func getDailyFat() {
        guard let fatType = HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal) else { return }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: fatType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.dailyFat = sum.doubleValue(for: .gram())
                    print("Fetched dietary fat consumed: \(self.dailyFat) g")
                } else {
                    print("No dietary fat data found or error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        healthStore.execute(query)
    }
    
    func getDailyCarbs() {
        guard let carbsType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates) else { return }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: carbsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.dailyCarbs = sum.doubleValue(for: .gram())
                    print("Fetched dietary carbs consumed: \(self.dailyCarbs) g")
                } else {
                    print("No dietary carbs data found or error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        healthStore.execute(query)
    }






    
    //    private func getMostRecentHeight() {
    //        fetchMostRecentQuantitySample(typeIdentifier: .height) { sample in
    //            if let quantity = sample?.quantity {
    //                let heightValue = quantity.doubleValue(for: .meterUnit(with: .centi))
    //                DispatchQueue.main.async {
    //                    self.height = heightValue
    //                }
    //            }
    //        }
    //    }
    
    
//    private func getMostRecentWeight() {
//        fetchMostRecentQuantitySample(typeIdentifier: .bodyMass) { sample in
//            if let quantity = sample?.quantity {
//                let weightValue = quantity.doubleValue(for: .gramUnit(with: .kilo))
//                DispatchQueue.main.async {
//                    self.weight = weightValue
//                }
//            }
//        }
//    }
    
    private func getDateOfBirth() {
        do {
            let components = try healthStore.dateOfBirthComponents()
            if let date = Calendar.current.date(from: components) {
                DispatchQueue.main.async {
                    self.dateOfBirth = date
                }
            }
        } catch {
            print("Failed to read date of birth: \(error.localizedDescription)")
        }
    }
    
    
    
    private func getActiveEnergyBurnedToday() {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.dailyCaloriesBurned = sum.doubleValue(for: .kilocalorie())
                }
            }
        }
        healthStore.execute(query)
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
    
    //    func saveHeight(_ cm: Double) {
    //        let type = HKQuantityType.quantityType(forIdentifier: .height)!
    //        let quantity = HKQuantity(unit: .meterUnit(with: .centi), doubleValue: cm)
    //        let sample = HKQuantitySample(type: type, quantity: quantity, start: Date(), end: Date())
    //
    //        healthStore.save(sample) { success, _ in
    //            if success {
    //                DispatchQueue.main.async {
    //                    self.height = cm
    //                }
    //            }
    //        }
    //
    //    }
    
    //    func saveWeight(_ kg: Double) {
    //        let type = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
    //        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: kg)
    //        let sample = HKQuantitySample(type: type, quantity: quantity, start: Date(), end: Date())
    //
    //        healthStore.save(sample) { success, _ in
    //            if success {
    //                DispatchQueue.main.async {
    //                    self.weight = kg
    //                }
    //            }
    //        }
    //
    //    }
    
    private func fetchMostRecentQuantitySample(typeIdentifier: HKQuantityTypeIdentifier, completion: @escaping (HKQuantitySample?) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: typeIdentifier) else {
            completion(nil)
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            let sample = samples?.first as? HKQuantitySample
            DispatchQueue.main.async {
                completion(sample)
            }
        }
        
        healthStore.execute(query)
    }
    
    
    func calculateTDEE() {
        guard let weight = weight,
              let height = height,
              let biologicalSex = biologicalSex,
              let dob = dateOfBirth else {
            print("Missing data for TDEE calculation")
            return
        }
        
        let age = Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 20
        var bmr: Double = 0
        
        switch biologicalSex {
        case .male:
            // Men: BMR = 88.362 + (13.397 × weight in kg) + (4.799 × height in cm) − (5.677 × age)
            bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
        case .female:
            // Women: BMR = 447.593 + (9.247 × weight in kg) + (3.098 × height in cm) − (4.330 × age)
            bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * Double(age))
        default:
            print("Biological sex not set, unable to compute BMR")
            return
        }
        
        DispatchQueue.main.async {
            self.TDEE = bmr
        }
    }
    
    
    func needsManualInput() -> Bool {
        return biologicalSex == nil || height == nil || weight == nil
    }
}
