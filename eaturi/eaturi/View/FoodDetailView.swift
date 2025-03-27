import SwiftUI

struct FoodDetailView: View {
    let item: FoodModel
    @Binding var isPresented: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    @Binding var showDetailModal: Bool
    @State private var quantity: Int

    init(item: FoodModel,
         isPresented: Binding<Bool>,
         cartItems: Binding<[UUID: Int]>,
         isCartVisible: Binding<Bool>,
         showDetailModal: Binding<Bool>) {
        self.item = item
        _isPresented = isPresented
        _cartItems = cartItems
        _isCartVisible = isCartVisible
        _showDetailModal = showDetailModal
        _quantity = State(initialValue: cartItems.wrappedValue[item.id] ?? 0)
    }

    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .frame(maxWidth: 320, maxHeight: 260)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 10)

            Text(item.name)
                .font(.title2)
                .fontWeight(.bold)

            Text("Harga: Rp\(item.price)")
                .font(.headline)
                .foregroundColor(.orange)
                .padding(.top, 4)

            Text("Nutrition")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            HStack {
                NutritionInfoView(label: "Calories", value: item.calories)
                NutritionInfoView(label: "Protein", value: item.protein)
                NutritionInfoView(label: "Fiber", value: item.fiber)
                NutritionInfoView(label: "Fat", value: item.fat)
                NutritionInfoView(label: "Carbs", value: item.carbs)
            }

            HStack(spacing: 10) {
                QuantityControl(
                    quantity: $quantity,
                    onIncrement: {
                        quantity += 1
                    },
                    onDecrement: {
                        if quantity > 0 {
                            quantity -= 1
                        }
                    }
                )
                .padding(.vertical, 10)

                Button {
                    if quantity > 0 {
                        cartItems[item.id] = quantity
                        isCartVisible = true
                        isPresented = false
                        showDetailModal = false
                    }
                } label: {
                    Text("Add to MyLunch")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.colorPrimary)
                        .cornerRadius(.infinity)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .presentationDetents([.height(500)])
        .onTapGesture {
            isPresented = false
            showDetailModal = false
        }
    }
}

struct NutritionInfoView: View {
    var label: String
    var value: Int

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
            Text("\(value)g")
                .font(.caption)
                .foregroundColor(.orange)
        }
        .frame(width: 70, height: 100)
    }
}
