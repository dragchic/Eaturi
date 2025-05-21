import SwiftUI
import SwiftData
import WatchConnectivity

struct FoodHighestList: View {
    @Query var historyRecords: [HistoryRecord]
    @Query var allFoods: [FoodModel]
    var selectedDate: Date

    var topFoods: [FoodModelWithCalories] {
        let calendar = Calendar.current
        let recordsToday = historyRecords.filter {
            calendar.isDate($0.timestamp, inSameDayAs: selectedDate)
        }

        // Gabungkan semua cart dari semua record
        var totalFoodDict: [UUID: Int] = [:]

        for record in recordsToday {
            for (id, qty) in record.cart {
                totalFoodDict[id, default: 0] += qty
            }
        }

        // Hitung kalori per item
        let foodCalories: [(FoodModel, Int)] = totalFoodDict.compactMap { id, qty in
            guard let food = allFoods.first(where: { $0.id == id }) else {
                print("Food dengan ID \(id) tidak ditemukan")
                return nil
            }
            print("\(food.name): \(food.calories * qty) kcal")
            return (food, food.calories * qty)
        }
        
        SharedDefaultsManager.saveTopFoods(
            foodCalories
                .sorted(by: { $0.1 > $1.1 })
                .prefix(5) // Simpan 5 makanan
                .map { SharedDefaultsManager.FoodItem(name: $0.0.name, calories: $0.1) }
        )

        func sendTopFoodsToWatch(_ foods: [SharedDefaultsManager.FoodItem]) {
            if WCSession.default.isReachable {
                let payload = foods.map { ["name": $0.name, "calories": $0.calories] }
                WCSession.default.sendMessage(["topFoods": payload], replyHandler: nil, errorHandler: nil)
            }
        }



        return foodCalories
            .sorted(by: { $0.1 > $1.1 })
            .prefix(4)
            .map { FoodModelWithCalories(food: $0.0, totalCalories: $0.1) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Food Highest in Calories")
                .font(.system(size: 16, weight: .semibold))
                .padding(.bottom, 5)

            if topFoods.isEmpty {
                VStack{
                    Text("No data for this day")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                }
                .frame(width: 320) 
                .background(Color.white)
                .cornerRadius(8)
                
            } else {
                ForEach(topFoods, id: \.food.id) { item in
                    HStack {
                        Text(item.food.name)
                        Spacer()
                        Text("\(item.totalCalories) kcal")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .frame(width: 310)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 25)
        .padding(.bottom, 40)
        .onAppear {
            let foodItemsToSave = topFoods.map {
                SharedDefaultsManager.FoodItem(name: $0.food.name, calories: $0.totalCalories)
            }
            SharedDefaultsManager.saveTopFoods(foodItemsToSave)
            print(foodItemsToSave)
            
        }
    }
}

struct FoodModelWithCalories {
    var food: FoodModel
    var totalCalories: Int
}

//struct FoodModel: Identifiable {
//    let id: UUID
//    let name: String
//    let calories: Int
//}


//struct MockFoodHighestList: View {
//    var body: some View {
//        let sampleTopFoods: [FoodModelWithCalories] = [
//            .init(food: FoodModel(id: UUID(), name: "Ayam Goreng", calories: 180), totalCalories: 360),
//            .init(food: FoodModel(id: UUID(), name: "Dori Asam Manis", calories: 135), totalCalories: 270),
//            .init(food: FoodModel(id: UUID(), name: "Ayam Gulai", calories: 148), totalCalories: 295),
//            .init(food: FoodModel(id: UUID(), name: "Nasi Uduk", calories: 205), totalCalories: 410)
//        ]
//
//        VStack(alignment: .leading) {
//            Text("Food Highest in Calories")
//                .font(.system(size: 16, weight: .semibold))
//                .padding(.bottom, 5)
//
//            ForEach(sampleTopFoods, id: \.food.id) { item in
//                HStack {
//                    Text(item.food.name)
//                    Spacer()
//                    Text("\(item.totalCalories) kcal")
//                        .foregroundColor(.gray)
//                }
//                .padding(.vertical, 8)
//                .padding(.horizontal)
//                .background(Color.white)
//                .cornerRadius(8)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .padding(.horizontal, 25)
//        .padding(.bottom, 40)
//    }
//}
//
//#Preview {
//    MockFoodHighestList()
//}


