import SwiftUI

struct CartPopUp: View {
    @Binding var cartItems: [UUID: Int]
    @Binding var foodItems: [FoodModel]
    var onTap: () -> Void
    
    var totalQuantity : Int {
        CartCalculationUtility.calculateTotalQuantity(
            cartItems: cartItems
        )
    }
    
    var totalCalories: Int {
        CartCalculationUtility.calculateTotalCalories(
            cartItems: cartItems,
            foodItems: foodItems
        )
    }
    
    var totalPrice: Int {
        CartCalculationUtility.calculateTotalPrice(
            cartItems: cartItems,
            foodItems: foodItems
        )
    }
    
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
                VStack(alignment: .leading, spacing: 3){
                    Text("\(totalQuantity) items")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    Text("Rp\(totalPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                }
                
                Spacer()
                
                HStack(spacing: 10){
                    HStack{
                        Image(systemName:"flame.fill")
                            .foregroundColor(.orange)
                        
                        Text("\(totalCalories) kcal")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(30)
                    
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
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
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
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


