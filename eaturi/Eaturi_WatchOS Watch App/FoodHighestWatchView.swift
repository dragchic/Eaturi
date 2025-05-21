//
//  FoodHighestWatch.swift
//  eaturi
//
//  Created by Grachia Uliari on 14/05/25.
//

import SwiftUI

struct FoodHighestListWatchView: View {
    let topFoods: [SharedDefaultsManager.FoodItem]

    init(topFoods: [SharedDefaultsManager.FoodItem]) {
        self.topFoods = topFoods
        for food in topFoods {
            print("\(food.name) - \(food.calories) kcal")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header tetap di atas
            HStack(alignment: .top) {
                Text("Food high in calories")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
                VStack {
                    Text("Today")
                        .font(.headline)
                        .foregroundColor(Color("neon"))
                }
                .padding(.top, 18)
            }
            .padding(.bottom, 2)

            // Scrollable list
            ScrollView {
                VStack(spacing: 6) {
                    ForEach(topFoods.prefix(5), id: \.name) { item in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(Color("neon"))
                            Text("\(item.calories) kcal")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(Color("neon").opacity(0.8))
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("neon").opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .frame(width: 195, height: 210)
        .padding(.horizontal, 10)
        .padding(.top, 0)
        .padding(.bottom, 0)
        .onAppear {
            let fetched = SharedDefaultsManager.fetchTopFoods()
            print("🍽 Top foods di watchOS: \(fetched.map { "\($0.name): \($0.calories)" })")
        }
    }
}

#Preview {
    let sampleFoods: [SharedDefaultsManager.FoodItem] = [
        .init(name: "Ayam Goreng Tepung", calories: 360),
        .init(name: "Dori Asam Manis", calories: 270),
        .init(name: "Ayam Gulai", calories: 295),
        .init(name: "Nasi Uduk", calories: 410),
        .init(name: "Mie Goreng", calories: 470)
    ]
    return FoodHighestListWatchView(topFoods: sampleFoods)
}



