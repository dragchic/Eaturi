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
                VStack(alignment: .leading){
                    Text("\(totalQuantity) items")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(Color.colororen)
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
                        .scaledToFit()
                        .frame(width: 30, height: 30)
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
