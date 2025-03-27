import SwiftUI

struct HistoryCardView: View {
    let products: [UUID: Int] // Dictionary of product IDs and their quantities

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Date and item count (larger text)
            Text("11 March 2025, \(products.count) items")
                .font(.title2)
                .foregroundColor(.secondary)

            // Product images with dynamic display
            HStack(spacing: 12) {
                let productIDs = Array(products.keys)
                let displayedProducts = productIDs.prefix(2)
                let remainingCount = products.count - displayedProducts.count

                ForEach(displayedProducts, id: \.self) { productID in
                    ProductImageView(productID: productID)
                        .frame(width: 100, height: 100) // Increased size
                }

                if remainingCount > 0 {
                    AdditionalProductsView(count: remainingCount)
                        .frame(width: 100, height: 100) // Increased size
                }
            }

            // Calorie information and total price
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("2000 Kcalories")
                        .font(.body)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Rp 150.000")
                    .font(.body)
                    .foregroundColor(Color("colorPrimary"))
            }

            // Right-aligned "Pick Again" button
            HStack {
                Spacer()
                Button(action: {
                    // Define the action for the button here
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
//        .padding() // Outer padding to separate from screen edges
    }
}

struct ProductImageView: View {
    let productID: UUID

    var body: some View {
        Image("otak_otak") // Replace with actual image fetching logic
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
    HistoryCardView(products: [
        UUID(): 1,
        UUID(): 2,
        UUID(): 1,
    ])
}
