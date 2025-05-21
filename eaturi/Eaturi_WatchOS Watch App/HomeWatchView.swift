////
////  HomeWatchView.swift
////  eaturi
////
////  Created by Grachia Uliari on 15/05/25.
////
//
//import SwiftUI
//import HealthKit
//
//struct HomeWatchView: View {
//    @EnvironmentObject var healthManager: HealthManager
//    @StateObject var wcManager = WatchSessionDelegate()
//
////    var selectedDate: Date
//    
//    @State private var topFoods: [SharedDefaultsManager.FoodItem] = []
//
//    private var target: Int { Int(healthManager.TDEE ?? 0) }
//    private var consumed: Int { Int(healthManager.dailyCaloriesIntake) }
//    private var burned: Int { Int(healthManager.dailyCaloriesBurned) }
//    
//    
//    var body: some View {
//        TabView {
//            VStack (spacing: 0){
////                HStack (spacing: 5){
//                    CalorieArcView(totalTarget: target, consumed: consumed, burned: burned)
////                        .frame(width: 110, height: 115)
////                        .background(Color.gray.opacity(0.2))
////                        .cornerRadius(15)
//
//                    
////                }
// 
//                VStack(alignment: .leading, spacing: 4){
//                    HStack(spacing: 10) {
//                        MacroProgress(name: "Protein", current: healthManager.dailyProtein, total: healthManager.targetProtein)
//                        MacroProgress(name: "Fat", current: healthManager.dailyFat, total: healthManager.targetFat)
//                        MacroProgress(name: "Carbs", current: healthManager.dailyCarbs, total: healthManager.targetCarbs)
//                    }
//                    
//                }
//                .padding(.horizontal, 10)
//                .padding(.top, 0)
//                .frame(width: 195, height: 70)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(13)
//                .padding(.bottom, 10)
//                
//                
//            }
//            
//            FoodHighestListWatchView(topFoods: wcManager.topFoods)
//        }
//        .tabViewStyle(.page)
//        .onAppear {
//            topFoods = SharedDefaultsManager.fetchTopFoods()
//            
//            for food in topFoods.prefix(5) {
//                    print("- \(food.name): \(food.calories) kcal")
//                }
//        }
//    }
//}
//
//#Preview {
//    HomeWatchView()
//        .environmentObject(HealthManager())
//}
