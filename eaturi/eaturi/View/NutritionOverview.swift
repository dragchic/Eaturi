//
//  NutritionOverview.swift
//  eaturi
//
//  Created by Grachia Uliari on 11/05/25.
//

import SwiftUI

struct NutritionOverview: View {
    @EnvironmentObject var healthManager: HealthManager
    var selectedDate: Date

    private var target: Int { Int(healthManager.TDEE ?? 0) }
    private var consumed: Int { Int(healthManager.dailyCaloriesIntake) }
    private var burned: Int { Int(healthManager.dailyCaloriesBurned) }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 30) {
                CalorieArcView(totalTarget: target, consumed: consumed, burned: burned)
                    .padding(.top, 15)

                VStack(alignment: .leading, spacing: 10) {
                    NutritionBox(title: "Target", value: target)
                    NutritionBox(title: "Burned", value: burned)
                }
            }
            .padding(.leading, 15)
            .padding(.horizontal, 25)

            HStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Consumed")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("BlackGray"))
                    Text("\(consumed)")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("BlackGray"))
                    Text("Kcal")
                        .font(.system(size: 14))
                        .foregroundColor(Color("BlackGray"))
                }

                VStack(alignment: .leading, spacing: 14) {
                    MacroProgress(name: "Protein", current: max(0, healthManager.dailyProtein), total: healthManager.targetProtein)
                    MacroProgress(name: "Fat", current: max(0, healthManager.dailyFat), total: healthManager.targetFat)
                    MacroProgress(name: "Carbs", current: max(0, healthManager.dailyCarbs), total: healthManager.targetCarbs)
                }
            }
            .frame(width: 310, height: 150)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.top, 4)
    }
        
}


