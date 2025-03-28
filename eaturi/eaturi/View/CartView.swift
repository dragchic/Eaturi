import SwiftUI

struct CartView: View {
    var totalCalories: Int
    var totalPrice: Int
    @Binding var cartItems: [UUID: Int]
    @Binding var foodItems: [FoodModel]
    @State private var localCartItems: [UUID: Int]
    @Environment(\.presentationMode) var presentationMode
    
    init(totalCalories: Int, totalPrice: Int, cartItems: Binding<[UUID: Int]>, foodItems: Binding<[FoodModel]>) {
        self.totalCalories = totalCalories
        self.totalPrice = totalPrice
        _cartItems = cartItems
        _foodItems = foodItems
        _localCartItems = State(initialValue: cartItems.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack(spacing: 20){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .foregroundColor(.colorPrimary)
                        .frame(width: 33, height: 33)
                        .background(Color.clear)
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
            
            // Cart Items List
            ScrollView {
                Spacer()
                VStack(spacing: 16) {
                    ForEach(localCartItems.compactMap { key, value -> (FoodModel, Int)? in
                        if let item = foodItems.first(where: { $0.id == key }) {
                            return (item, value)
                        }
                        return nil
                    }, id: \.0.id) { item, quantity in
                        HStack {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.subheadline)
                                
                                HStack {
                                    Image(systemName: "flame")
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
                            
                            // Quantity Control
                            QuantityControl(
                                quantity: Binding(
                                    get: { localCartItems[item.id] ?? 0 },
                                    set: { newValue in
                                        if newValue > 0 {
                                            localCartItems[item.id] = newValue
                                            cartItems = localCartItems
                                        } else {
                                            localCartItems.removeValue(forKey: item.id)
                                            cartItems = localCartItems
                                        }
                                    }
                                ),
                                onIncrement: {
                                    localCartItems[item.id, default: 0] += 1
                                    cartItems = localCartItems
                                },
                                onDecrement: {
                                    if var currentQuantity = localCartItems[item.id], currentQuantity > 1 {
                                        currentQuantity -= 1
                                        localCartItems[item.id] = currentQuantity
                                        cartItems = localCartItems
                                    } else {
                                        localCartItems.removeValue(forKey: item.id)
                                        cartItems = localCartItems
                                    }
                                }
                            )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
            }
            
            // Summary Section
            VStack(spacing: 16) {
                HStack{
                    Text("Summary")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text("Calories")
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .regular))
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(totalCalories) kcal")
                            .foregroundColor(.secondary)
                            .font(.system(size: 17, weight: .medium))
                    }
                }
                .padding(.horizontal)
                .padding(6)
                
                HStack {
                    Text("Price")
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .regular))
                    
                    Spacer()
                    
                    Text("Rp \(totalPrice)")
                        .foregroundColor(.colorPrimary)
                        .font(.system(size: 17, weight: .medium))
                }
                .padding(.horizontal)
                .padding(6)
            }
            .padding(.vertical)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
            
            // Save to History Button
            Button(action: saveToHistory) {
                Text("Save to History")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colorPrimary)
                    .cornerRadius(.infinity)
                    .padding()
            }
        }
        .background(.abubg)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
    
    private func saveToHistory() {
        // Implement save to history logic
        print("Saved to history")
    }
}

// Preview with sample data
#Preview {
    let sampleFoodItems = [
        FoodModel(name: "Nasi Goreng", image: "ayam_asam_manis", price: 20000, calories: 300, protein: 20, carbs: 50, fiber: 5, fat: 15, isPopular: true, categories: ["Nasi"], description: "Fried rice"),
        FoodModel(name: "Ayam Goreng Asam Manis", image: "ayam_asam_manis", price: 25000, calories: 200, protein: 30, carbs: 10, fiber: 30, fat: 10, isPopular: false, categories: ["Ayam", "Asam Manis"], description: "Sweet and sour chicken")
    ]
    
    let sampleCartItems: [UUID: Int] = [
        sampleFoodItems[0].id: 1,
        sampleFoodItems[1].id: 1
    ]
    
    let totalCalories = sampleCartItems.reduce(0) { total, entry in
        let item = sampleFoodItems.first { $0.id == entry.key }
        return total + ((item?.calories ?? 0) * entry.value)
    }
    
    let totalPrice = sampleCartItems.reduce(0) { total, entry in
        let item = sampleFoodItems.first { $0.id == entry.key }
        return total + ((item?.price ?? 0) * entry.value)
    }
    
    return CartView(
        totalCalories: totalCalories,
        totalPrice: totalPrice,
        cartItems: .constant(sampleCartItems),
        foodItems: .constant(sampleFoodItems)
    )
}
