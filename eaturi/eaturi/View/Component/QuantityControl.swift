import SwiftUI

struct QuantityControl: View {
    @Binding var quantity: Int
    var onIncrement: () -> Void
    var onDecrement: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 6, height: 6)
                    .foregroundColor(.white)
                    .padding(12) // Inner padding
                    .background(Color("colorPrimary"))
                    .clipShape(Circle())
            }
            .frame(width: 25, height: 25) // Ensure uniform size

            Text("\(quantity)")
                .font(.headline)
                .frame(width: 30, alignment: .center)

            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 6, height: 6)
                    .foregroundColor(.white)
                    .padding(12) // Inner padding
                    .background(Color("colorPrimary"))
                    .clipShape(Circle())
            }
            .frame(width: 25, height: 25)
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(30)
    }
}
