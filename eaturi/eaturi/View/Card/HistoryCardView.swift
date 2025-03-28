import SwiftUI

struct HistoryCardView: View {
    let record: HistoryRecord // Use HistoryRecord instead of products dictionary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Date and item count (larger text)
            Text(dateFormatter.string(from: record.date) + ", \(record.cart.count) items")
                .font(.title2)
                .foregroundColor(.secondary)

            // Product images with dynamic display
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

            // Calorie information and total price
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange) // Replace .colorOren with .orange or define it
                    Text("\(record.totalCalories) Kcalories")
                        .font(.body)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Rp \(record.totalPrice)")
                    .font(.body)
                    .foregroundColor(Color("colorPrimary"))
            }

            // Right-aligned "Pick Again" button
            HStack {
                Spacer()
                Button(action: {
                    // Define the action for the button here (e.g., re-add items to cart)
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
    
    // Date formatter for consistent display
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

struct ProductImageView: View {
    let productID: UUID

    var body: some View {
        Image("otak_otak") // Replace with actual image fetching logic based on productID
            .resizable()
            .frame(width: 100, height: 100)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 8))
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
    HistoryCardView(record: HistoryRecord(
        date: Date(),
        cart: [UUID(): 1, UUID(): 2, UUID(): 1],
        totalPrice: 150000,
        totalCalories: 2000,
        totalProtein: 50,
        totalCarbs: 100,
        totalFiber: 20,
        totalFat: 30
    ))
}
