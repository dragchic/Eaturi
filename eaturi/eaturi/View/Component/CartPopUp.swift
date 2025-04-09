import SwiftUI

struct CartPopUp: View {
    @Binding var cartItems: [UUID: Int]
    @Binding var foodItems: [FoodModel]
    var onTap: () -> Void

    var totalQuantity: Int {
        CartCalculationUtility.calculateTotalQuantity(cartItems: cartItems)
    }

    var totalCalories: Int {
        CartCalculationUtility.calculateTotalCalories(cartItems: cartItems, foodItems: foodItems)
    }

    var totalPrice: Int {
        CartCalculationUtility.calculateTotalPrice(cartItems: cartItems, foodItems: foodItems)
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
        HStack {
            // Left side: total items and price
            VStack(alignment: .leading, spacing: 3) {
                Text("\(totalQuantity) items")
                    .foregroundColor(.white)
                    .font(.caption)

                Text("Rp\(totalPrice)")
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
            }.padding(.leading, 10)

            Spacer()

            // Right side: total calories and chevron
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)

                    Text("\(totalCalories) kcal")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.colorPrimary)
                        .lineLimit(1) // ✅ Prevent line wrap
                        .layoutPriority(1) // ✅ Make sure this text resists compression

                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(30)

                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.white)
                    .foregroundColor(.colorPrimary)
            }
        }
        .padding(.horizontal, 24) // ✅ Outer horizontal padding (both sides)
        .padding(.vertical) // Optional vertical padding
        .frame(maxWidth: .infinity)
        .background(Color.colorPrimary)
        .cornerRadius(.infinity)
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: -1)
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


