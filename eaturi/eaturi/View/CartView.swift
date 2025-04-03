import SwiftUI
import SwiftData

struct CartView: View {
    @Binding var cartItems: [UUID: Int]
    var foodItems: [FoodModel]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var totalCalories: Int {
        CartCalculationUtility.calculateTotalCalories(cartItems: cartItems, foodItems: foodItems)
    }
    
    var totalPrice: Int {
        CartCalculationUtility.calculateTotalPrice(cartItems: cartItems, foodItems: foodItems)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .foregroundColor(Color.colorPrimary)
                        .frame(width: 33, height: 33)
                }
                
                HStack(spacing: 0) {
                    Text("My")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blackGray)
                    
                    Text("Lunch")
                        .font(.title)
                        .bold()
                        .foregroundColor(.colorPrimary)
                }
                
                Spacer()
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 16) {
                    if cartItems.isEmpty {
                        Text("Your cart is empty")
                            .foregroundColor(.gray)
                            .padding()
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
            
            SummaryView(totalCalories: totalCalories, totalPrice: totalPrice)
            
            Button(action: saveToHistory) {
                Text("Save to History")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(cartItems.isEmpty ? Color.gray : Color.colorPrimary)
                    .cornerRadius(25)
                    .padding()
            }
            .disabled(cartItems.isEmpty)
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
    
    private func updateQuantity(for id: UUID, quantity: Int) {
        if quantity > 0 {
            cartItems[id] = quantity
        } else {
            cartItems.removeValue(forKey: id)
        }
    }
    
    private func saveToHistory() {
        print("⏳ Saving to history...")
        
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
        
        cartItems.removeAll()
        dismiss()
        
        print("✅ Save completed")
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
                    .font(.subheadline)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(item.calories) kcal")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text("Rp. \(item.price)")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            QuantityControl(
                quantity: $quantity,
                onIncrement: { quantity += 1 },
                onDecrement: { if quantity > 0 { quantity -= 1 } }
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
    }
}

struct SummaryView: View {
    var totalCalories: Int
    var totalPrice: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Summary")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
            }
            HStack {
                Text("Calories")
                    .foregroundColor(.black)
                Spacer()
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(totalCalories) kcal")
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                Text("Price")
                    .foregroundColor(.black)
                Spacer()
                Text("Rp \(totalPrice)")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
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
