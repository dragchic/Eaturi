import SwiftUI

struct QuantityControl: View {
    @Binding var quantity: Int
    var onIncrement: () -> Void
    var onDecrement: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                if quantity > 0 {
                    onDecrement()
                }
            }) {
                Image(systemName: "minus")
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }

            Text("\(quantity)")
                .font(.headline)
                .frame(minWidth: 30, alignment: .center)

            Button(action: {
                onIncrement()
            }) {
                Image(systemName: "plus")
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(30)
    }
}
