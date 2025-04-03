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
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    Image(item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 0.9) // Set width to 80% of parent
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240) // Adjust this if you want different height based on aspect ratio
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.top, 20)
                    Spacer()
                }
            }
            
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
                .foregroundColor(.ijotulisan)
            
            Text("Nutrition")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.newblek)
            
            // Nutritional Information
            HStack(spacing: 15) {
                ForEach(nutritionData, id: \.label) { data in
                    NutritionInfoView(label: data.label, value: data.value, imageName: data.image)
                }
            }
            .padding(.top, 8)
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
                    .foregroundColor(.colorOren)
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
