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
                    .frame(width: 9, height: 9)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color("colorPrimary"))
                    .clipShape(Circle())
            }
            .frame(width: 20, height: 20)

            Text("\(quantity)")
                .font(.headline)
                .frame(width: 30, alignment: .center)

            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 9, height: 9)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color("colorPrimary"))
                    .clipShape(Circle())
            }
            .frame(width: 21, height: 21)
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(30)
    }
}
