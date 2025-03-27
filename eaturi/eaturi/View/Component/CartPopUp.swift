import SwiftUI

struct CartPopUp: View {
    @Binding var cartItems: [UUID: Int]
    @Binding var foodItems: [FoodModel]
    var onTap: () -> Void   // Closure to trigger navigation

    // Total quantity of all items in the cart
    private var totalQuantity: Int {
        cartItems.values.reduce(0, +)
    }
    
    // Total calories computed using Int values
    private var totalCalories: Int {
        cartItems.reduce(0) { total, entry in
            if let foodItem = foodItems.first(where: { $0.id == entry.key }) {
                return total + (foodItem.calories * entry.value)
            }
            return total
        }
    }
    
    // Total price computed using Int values
    private var totalPrice: Int {
        cartItems.reduce(0) { total, entry in
            if let foodItem = foodItems.first(where: { $0.id == entry.key }) {
                return total + (foodItem.price * entry.value)
            }
            return total
        }
    }
    
    // Detailed list of cart items
    private var cartItemDetails: [(item: FoodModel, quantity: Int)] {
        cartItems.compactMap { key, value in
            if let foodItem = foodItems.first(where: { $0.id == key }) {
                return (foodItem, value)
            }
            return nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Your picked food")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Total Calories: \(totalCalories)")
                .foregroundColor(.white)
                .font(.caption)
            
            Text("Total Price: Rp\(totalPrice)")
                .foregroundColor(.white)
                .font(.caption)
            
            Text("Total Quantity: \(totalQuantity)")
                .foregroundColor(.white)
                .font(.caption)
            
            ForEach(cartItemDetails, id: \.item.id) { cartItem in
                Text("\(cartItem.item.name) x\(cartItem.quantity)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
    }
}
