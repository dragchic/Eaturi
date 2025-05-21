import SwiftUI
import SwiftData
import HealthKit

struct CartView: View {
    @Binding var cartItems: [UUID: Int]
    var foodItems: [FoodModel]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    let healthManager = HealthManager()
    
    @Binding var selectedTab: Int
    
    var totalCalories: Int {
        CartCalculationUtility.calculateTotalCalories(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalProtein: Int {
        CartCalculationUtility.calculateTotalProtein(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalFat: Int {
        CartCalculationUtility.calculateTotalFat(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalFiber: Int {
        CartCalculationUtility.calculateTotalFiber(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalCarbs: Int {
        CartCalculationUtility.calculateTotalCarbs(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalPrice: Int {
        CartCalculationUtility.calculateTotalPrice(cartItems: cartItems, foodItems: foodItems)
    }
    
    var body: some View {
        ZStack {
            // Background and main content
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("colorSecondary"), location: 0.0),
                        .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                        .init(color: Color("abubg"), location: 0.6)
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.backward.circle.fill")
                                .resizable()
                                .foregroundColor(Color.colorPrimary)
                                .frame(width: 33, height: 33)
                                .dynamicTypeSize(.xSmall...(.accessibility5))
                        }
                        
                        HStack(spacing: 0) {
                            Text("My")
                                .font(.system(.title, design: .default))
                                .bold()
                                .foregroundColor(.blackGray)
                                .dynamicTypeSize(.xSmall...(.accessibility5))
                            
                            Text("Lunch")
                                .font(.system(.title, design: .default))
                                .bold()
                                .foregroundColor(.colorPrimary)
                                .dynamicTypeSize(.xSmall...(.accessibility5))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack{
                        nutritionItem(icon: "flame.fill", value: "\(totalCalories)", label: "Calories", color: .orange)
                        separator()
                        nutritionItem(icon: "circle.hexagongrid.fill", value: "\(totalFat) g", label: "Fat", color: .yellow)
                        separator()
                        nutritionItem(icon: "bolt.fill", value: "\(totalProtein) g", label: "Protein", color: .red)
                        separator()
                        nutritionItem(icon: "chart.pie.fill", value: "\(totalCarbs) g", label: "Carbs", color: .blue)
                        separator()
                        nutritionItem(icon: "leaf.fill", value: "\(totalFiber) g", label: "Fiber", color: .green)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(width: UIFontMetrics.default.scaledValue(for: 340))
                    .padding(.vertical, UIFontMetrics.default.scaledValue(for: 16))
                    .padding(.horizontal, UIFontMetrics.default.scaledValue(for: 10))
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    ScrollView {
                        VStack(spacing: UIFontMetrics.default.scaledValue(for: 16)) {
                            if cartItems.isEmpty {
                                Text("Your cart is empty")
                                    .font(.system(.body, design: .default))
                                    .foregroundColor(.gray)
                                    .padding()
                                    .dynamicTypeSize(.xSmall...(.accessibility5))
                            } else {
                                ForEach(cartItems.compactMap { key, value -> (FoodModel, Binding<Int>)? in
                                    if let item = foodItems.first(where: { $0.id == key }) {
                                        return (item, Binding(
                                            get: { cartItems[key] ?? 0 },
                                            set: { newValue in updateQuantity(for: key, quantity: newValue) }
                                        ))
                                    }
                                    return nil
                                }, id: \.0.id) { item, quantity in
                                    CartItemView(item: item, quantity: quantity)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        saveToHistory()
                        iOSSessionManager.shared.setup()
                        
                        let foods = SharedDefaultsManager.fetchTopFoods()
                        iOSSessionManager.shared.sendTopFoodsToWatch(foods)
                        
                        iOSSessionManager.shared.sendNutritionDataToWatch(healthManager: healthManager)
                        
                        iOSSessionManager.shared.updateApplicationContext(with: healthManager)
                    }) {
                        Text("Save to History")
                            .font(.system(size: UIFontMetrics.default.scaledValue(for: 20)))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(height: UIFontMetrics.default.scaledValue(for: 40))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cartItems.isEmpty ? Color.gray : Color.colorPrimary)
                            .cornerRadius(100)
                            .padding()
                    }
                    .disabled(cartItems.isEmpty)
                }
                .navigationBarHidden(true)
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
    
    private func nutritionItem(icon: String, value: String, label: String, color: Color) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: UIFontMetrics.default.scaledValue(for: 15)))
                .foregroundStyle(color)
            Text(value)
                .font(.system(.subheadline, design: .default))
                .foregroundColor(.black)
                .dynamicTypeSize(.xSmall...(.accessibility5))
            Text(label)
                .font(.system(.caption, design: .default))
                .foregroundColor(.gray)
                .dynamicTypeSize(.xSmall...(.accessibility5))
        }
        .frame(maxWidth: .infinity)
    }
    
    private func separator() -> some View {
        Rectangle()
            .fill(Color("colorPrimary"))
            .frame(width: 1, height: UIFontMetrics.default.scaledValue(for: 40))
            .padding(.horizontal, 4)
    }
    
    private func updateQuantity(for id: UUID, quantity: Int) {
        if quantity > 0 {
            cartItems[id] = quantity
        } else {
            cartItems.removeValue(forKey: id)
        }
    }
    
    private func saveToHistory() {
        print("Saving to history...")
        
        let foodData = foodItems.reduce(into: [UUID: (Int, Int, Int, Int, Int, Int)]()) { result, item in
            result[item.id] = (
                item.price,
                item.calories,
                item.protein,
                item.carbs,
                item.fiber,
                item.fat
            )
        }
        
        HistoryManager.saveOrderHistory(
            cart: cartItems,
            modelContext: modelContext,
            foodData: foodData
        )
        
        print("📦 Total Calories: \(totalCalories) kcal")
        print("🥩 Protein: \(totalProtein) g")
        print("🍞 Carbs: \(totalCarbs) g")
        print("🌱 Fiber: \(totalFiber) g")
        print("🧈 Fat: \(totalFat) g")
        
        healthManager.saveNutrition(value: Double(totalCalories), unit: .kilocalorie(), typeIdentifier: .dietaryEnergyConsumed)
        healthManager.saveNutrition(value: Double(totalFat), unit: .gram(), typeIdentifier: .dietaryFatTotal)
        healthManager.saveNutrition(value: Double(totalCarbs), unit: .gram(), typeIdentifier: .dietaryCarbohydrates)
        healthManager.saveNutrition(value: Double(totalFiber), unit: .gram(), typeIdentifier: .dietaryFiber)
        healthManager.saveNutrition(value: Double(totalProtein), unit: .gram(), typeIdentifier: .dietaryProtein)
        
        cartItems.removeAll()
        
        // Switch to History tab (index 1) before dismissing
        selectedTab = 1
        dismiss()
        
        print("Save completed")
    }
}




struct CartItemView: View {
    var item: FoodModel
    @Binding var quantity: Int
    
    var body: some View {
        HStack {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundColor(.newblek)
                
                HStack(spacing: 4) {
                    Image(systemName:"flame.fill")
                        .foregroundColor(.orange)
                    Text("\(item.calories) kcal")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 3)
                
                HStack(spacing: 10) {
                    HStack(spacing: 3) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text("\(item.fat)g")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 3) {
                        Image(systemName: "bolt.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("\(item.protein)g")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 3) {
                        Image(systemName:"chart.pie.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("\(item.carbs)g")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 3)
            }
            
            Spacer()
            
            QuantityControl(
                quantity: $quantity,
                onIncrement: {
                    quantity += 1
                },
                onDecrement: {
                    if quantity > 0 {
                        quantity -= 1
                    }
                },
                buttonSize: 24,
                iconSize: 10,
                fontSize: 16,
                textSpacing: 0
            )
        }
        .frame(width: 340, height: 90)
        //        .padding(.top, 8)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        //        .shadow(radius: 5)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
