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
        HStack(spacing: 3) {
            HStack{
                VStack(alignment: .leading){
                    Text("\(totalQuantity) items")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.yellow)
                        Text("\(totalCalories)")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 20){
                    Text("Rp\(totalPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .scaledToFit()             // Keep the aspect ratio
                        .frame(width: 30, height: 30) // Adjust these values as needed for a larger image
                        .foregroundStyle(.white)
                }
            }
            .padding(.leading,20)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.colorPrimary)
        .cornerRadius(.infinity)
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    MainTabView()
}
