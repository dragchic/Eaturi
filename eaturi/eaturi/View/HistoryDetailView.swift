import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var foodItems: [FoodModel]
    
    var record: HistoryRecord
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("colorSecondary"), location: 0.0),
                    .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                    .init(color: Color("abubg"), location: 0.6)
                ]),
                startPoint: .topTrailing,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(dateFormatter.string(from: record.timestamp))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("\(record.cart.count) items · Rp \(record.totalPrice)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                    
                    // Nutrition summary
                    NutritionSummaryView(record: record)
                    
                    // Food items list
                    Text("Items")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    ForEach(Array(record.cart.keys), id: \.self) { foodId in
                        if let quantity = record.cart[foodId],
                           let food = findFood(byId: foodId) {
                            FoodItemView(food: food, quantity: quantity)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func findFood(byId id: UUID) -> FoodModel? {
        return foodItems.first { $0.id == id }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

// Nutrition summary component
struct NutritionSummaryView: View {
    let record: HistoryRecord
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Nutrition Summary")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                NutritionCard(
                    icon: "flame.fill",
                    color: .orange,
                    title: "Calories",
                    value: "\(record.totalCalories) kcal"
                )
                
                NutritionCard(
                    icon: "bolt.fill",
                    color: .red,
                    title: "Protein",
                    value: "\(record.totalProtein) g"
                )
            }
            
            HStack(spacing: 12) {
                NutritionCard(
                    icon: "chart.pie.fill",
                    color: .blue,
                    title: "Carbs",
                    value: "\(record.totalCarbs) g"
                )
                
                NutritionCard(
                    icon: "drop.fill",
                    color: .green,
                    title: "Fiber",
                    value: "\(record.totalFiber) g"
                )
            }
            
            NutritionCard(
                icon: "circle.hexagongrid.fill",
                color: .yellow,
                title: "Fat",
                value: "\(record.totalFat) g"
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct NutritionCard: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// Food item component
struct FoodItemView: View {
    let food: FoodModel
    let quantity: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.headline)
                
                Text("\(quantity) × Rp \(food.price)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(food.calories * quantity) kcal")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            Text("Rp \(food.price * quantity)")
                .font(.headline)
                .foregroundColor(Color("colorPrimary"))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
