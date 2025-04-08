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
        VStack(alignment: .leading, spacing: 16) {
            
                    Image(item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.top, 20)
                   
            
            
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
            
            Text("Nutrition")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.newblek)
            
            // Nutritional Information
            HStack {
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
            
            HStack(spacing: 10) {
                QuantityControl(
                    quantity: $quantity,
                    onIncrement: { quantity += 1 },
                    onDecrement: { if quantity > 0 { quantity -= 1 } }
                )
                .padding(.vertical, 10)
                .foregroundStyle(Color("newblek"))
                
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
                        .frame(width: 220, height: 60)
                        .background(Color.colorPrimary)
                        .cornerRadius(100)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(Color.white)
        .cornerRadius(20)
        .presentationDetents([.height(500)])
        .onTapGesture {
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

    
    private var nutritionData: [(label: String, value: Int, image: String)] {
        return [
            ("Kcal", item.calories, "calorie"),
            ("Fat", item.fat, "fat"),
            ("Protein", item.protein, "protein"),
            ("Carbs", item.carbs, "carbs"),
            ("Fiber", item.fiber, "fiber")
        ]
    }
}


struct NutritionInfoView: View {
    var label: String
    var value: Int
    var imageName: String
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 10){
                Image(imageName)
                    .foregroundColor(Color.colorOren)
                    .frame(width:40, height: 40)
                    .background(Color(.white))
                    .cornerRadius(100)
                
                VStack {
                    Text("\(value) g")
                        .foregroundStyle(.newblek)
                        .font(.system(size: 16))
                    
                    Text(label)
                        .foregroundStyle(.newblek)
                        .font(.system(size: 12))
                }
            }
            .padding(10)
            .frame(width: 62.5, height: 100)
            .frame(alignment: .center)
            .background(Color("colorTertiary"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("colorPrimary"), lineWidth: 2)
            )
        }
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

