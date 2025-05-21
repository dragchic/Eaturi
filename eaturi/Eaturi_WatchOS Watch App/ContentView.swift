//
//  ContentView.swift
//  Eaturi_WatchOS Watch App
//
//  Created by Grachia Uliari on 12/05/25.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager
    @StateObject var wcManager = WatchSessionDelegate()

//    var selectedDate: Date
    
    @State private var topFoods: [SharedDefaultsManager.FoodItem] = []

    private var target: Int { Int(healthManager.TDEE ?? 0) }
    private var consumed: Int { Int(healthManager.dailyCaloriesIntake) }
    private var burned: Int { Int(healthManager.dailyCaloriesBurned) }
    
    
    var body: some View {
        TabView {
            VStack (spacing: 0){
//                HStack (spacing: 5){
                    CalorieArcView(totalTarget: Int(wcManager.TDEE), consumed: wcManager.dailyCaloriesIntake, burned: Int(wcManager.dailyCaloriesBurned))
                
//                        .frame(width: 110, height: 115)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(15)

                    
//                }
 
                VStack(alignment: .leading, spacing: 4){
                    HStack(spacing: 16) {
                        MacroProgress(name: "Protein", current: wcManager.dailyProtein, total: (wcManager.TDEE * 0.2) / 4)
                        MacroProgress(name: "Fat", current: wcManager.dailyFat, total: (wcManager.TDEE * 0.25) / 9)
                        MacroProgress(name: "Carbs", current: wcManager.dailyCarbs, total: (wcManager.TDEE * 0.55) / 4)
                    }
                    
                }
                .padding(.horizontal, 10)
                
                .frame(width: 195, height: 70)
                .background(Color.gray.opacity(0.13))
                .cornerRadius(13)
                .padding(.bottom, 0)
                .padding(.top, 10)
                
                
            }
            
            FoodHighestListWatchView(topFoods: wcManager.topFoods)
        }
        .tabViewStyle(.page)
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.fetchAllHealthData()
            
            let today = Calendar.current.startOfDay(for: Date())
                healthManager.fetchDailyData(for: today)
            
            
            topFoods = SharedDefaultsManager.fetchTopFoods()
            
            for food in topFoods.prefix(5) {
                    print("- \(food.name): \(food.calories) kcal")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
}
