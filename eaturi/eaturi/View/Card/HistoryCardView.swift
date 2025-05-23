import SwiftUI
import _SwiftData_SwiftUI

struct HistoryCardView: View {
    let record: HistoryRecord
    let onPickAgain: ([UUID: Int]) -> Void
    
    
    var body: some View {
        NavigationLink(destination: HistoryDetailView(record: record)) {
            VStack(alignment: .leading, spacing: 16) {
                Text(dateFormatter.string(from: record.timestamp) + ", \(record.totalQuantity) items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack(spacing: 12) {
                    let productIDs = Array(record.cart.keys)
                    let displayedProducts = productIDs.prefix(2)
                    let remainingCount = record.cart.count - displayedProducts.count
                    ForEach(displayedProducts, id: \.self) { productID in
                        ProductImageView(productID: productID)
                            .frame(width: 100, height: 100)
                    }
                    if remainingCount > 0 {
                        AdditionalProductsView(count: remainingCount)
                            .frame(width: 100, height: 100)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                            Text("\(record.totalCalories) kcal")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        HStack(spacing: 10) {
                            HStack(spacing: 3) {
                                Image(systemName: "circle.hexagongrid.fill")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                Text("\(record.totalFat)g")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 1) {
                                Image(systemName: "bolt.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Text("\(record.totalProtein)g")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 3) {
                                Image(systemName:"chart.pie.fill")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text("\(record.totalCarbs)g")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    }
            
                    Spacer()
                    Text("Rp \(record.totalPrice)")
                        .font(.body)
                        .foregroundColor(Color("colorPrimary"))
                }
                HStack {
                    Spacer()
                    Button(action: {
                        onPickAgain(record.cart)
                    }) {
                        Text("Pick Again")
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("colorPrimary"))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Ensures the card doesn't look like a button
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

struct ProductImageView: View {
    @Query private var foodItems: [FoodModel]
    let productID: UUID
    
    var body: some View {
        if let food = foodItems.first(where: { $0.id == productID }) {
            Image(food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            // Fallback image if food is not found
            Image("otak_otak") // You can change this to a placeholder image
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct AdditionalProductsView: View {
    let count: Int

    var body: some View {
        Text("+\(count)")
            .font(.headline)
            .frame(width: 100, height: 100)
            .background(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
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
