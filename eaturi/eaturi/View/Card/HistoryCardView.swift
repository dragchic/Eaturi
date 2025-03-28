import SwiftUI

struct HistoryCardView: View {
    let record: HistoryRecord
    let onPickAgain: ([UUID: Int]) -> Void // Closure to trigger navigation and cart update
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(dateFormatter.string(from: record.timestamp) + ", \(record.cart.count) items")
                .font(.title2)
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
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(record.totalCalories) Kcalories")
                        .font(.body)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Rp \(record.totalPrice)")
                    .font(.body)
                    .foregroundColor(Color("colorPrimary"))
            }

            HStack {
                Spacer()
                Button(action: {
                    onPickAgain(record.cart) // Trigger the closure with the record's cart
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
