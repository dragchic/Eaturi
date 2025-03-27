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
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(12) // Inner padding
                    .background(Color("colorPrimary"))
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44) // Ensure uniform size

            Text("\(quantity)")
                .font(.headline)
                .frame(width: 30, alignment: .center)

            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(12) // Inner padding
                    .background(Color("colorPrimary"))
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(30)
    }
}

#Preview {
    MainTabView()
}
