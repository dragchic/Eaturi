import SwiftUI

struct FoodDetailView: View {
    // MARK: - Properties
    let item: FoodModel
    let isAvailableToday: Bool

    @Binding var isPresented: Bool
    @Binding var cartItems: [UUID: Int]
    @Binding var isCartVisible: Bool
    @Binding var showDetailModal: Bool
    @State private var quantity: Int = 0
    @State private var initialQuantity: Int = 0
    
    // MARK: - Initialization
    init(item: FoodModel,
         isPresented: Binding<Bool>,
         cartItems: Binding<[UUID: Int]>,
         isCartVisible: Binding<Bool>,
         showDetailModal: Binding<Bool>,
         isAvailableToday: Bool) {
        self.item = item
        _isPresented = isPresented
        _cartItems = cartItems
        _isCartVisible = isCartVisible
        _showDetailModal = showDetailModal
        self.isAvailableToday = isAvailableToday
        let initialValue = cartItems.wrappedValue[item.id] ?? 0
        _quantity = State(initialValue: initialValue)
        _initialQuantity = State(initialValue: initialValue)
    }

    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            foodImageView
            detailsSection
            nutritionSection
            actionButtons
        }
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(20)
        .presentationDetents([.medium])
        .onTapGesture {
            isPresented = false
            showDetailModal = false
        }
        .onAppear {
            let initialValue = cartItems[item.id] ?? 0
            quantity = initialValue
            initialQuantity = initialValue
        }
        .grayscale(isAvailableToday ? 0 : 1)
        .opacity(isAvailableToday ? 1 : 0.7)
    }
    
    // MARK: - Subviews
    private var foodImageView: some View {
        GeometryReader { geometry in
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 0.98, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.top, 20)
                .position(x: geometry.size.width / 2, y: 240 / 2 + 20)
//                .saturation(isAvailableToday ? 1 : 0)
//                .opacity(isAvailableToday ? 1 : 0.5)
        }
        .frame(height: 260)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.newblek)
            
            Text(item.foodDescription)
                .font(.body)
                .foregroundStyle(.abu)
            
            Text("Rp\(item.price)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.colorPrimary)
        }
    }
    
    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Nutrition")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.newblek)
            
            HStack{
                nutritionItem(icon: "flame.fill", value: "\(item.calories)", label: "Calories", color: .orange)
                separator()
                nutritionItem(icon: "circle.hexagongrid.fill", value: "\(item.fat) g", label: "Fat", color: .yellow)
                separator()
                nutritionItem(icon: "bolt.fill", value: "\(item.protein) g", label: "Protein", color: .red)
                separator()
                nutritionItem(icon: "chart.pie.fill", value: "\(item.carbs) g", label: "Carbs", color: .blue)
                separator()
                nutritionItem(icon: "leaf.fill", value: "\(item.fiber) g", label: "Fiber", color: .green)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 10) {
            if isAvailableToday {
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
                    buttonSize: 40,
                    iconSize: 15,
                    fontSize: 25
                )
                .padding(.vertical, 10)
                .foregroundStyle(Color("newblek"))

                Button(action: addToCart) {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(Color.colorPrimary)
                        .cornerRadius(100)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                .disabled(quantity <= 0)
            } else {
                Button(action: {}) {
                    Text("Not Available Today")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .cornerRadius(100)
                }
                .disabled(true)
            }
        }
        .padding(.bottom, 20)
    }

    // Computed property to determine button text
    private var buttonText: String {
        print("initialQuantity: \(initialQuantity), quantity: \(quantity)")
        if initialQuantity >= 0 && quantity != initialQuantity {
            return "Update MyLunch"
        } else {
            return "Add to MyLunch"
        }
    }
    
    // MARK: - Helper Methods
    private func addToCart() {
        if quantity > 0 {
            cartItems[item.id] = quantity
            isCartVisible = true
            isPresented = false
            showDetailModal = false
        } else {
            cartItems.removeValue(forKey: item.id)
            isPresented = false
            showDetailModal = false
        }
    }
    
    private func nutritionItem(icon: String, value: String, label: String, color: Color) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.black)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private func separator() -> some View {
        Rectangle()
            .fill(Color("colorPrimary"))
            .frame(width: 1, height: 40)
            .padding(.horizontal, 4)
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
