import SwiftUI
struct QuantityControl: View {
    @Binding var quantity: Int
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    var buttonSize: CGFloat = 32
    var iconSize: CGFloat = 12
    var textWidth: CGFloat = 30
    var fontSize: CGFloat = 16  // Added parameter for font size
    
    var body: some View {
        HStack(spacing: 12) {
            // Minus button
            Button(action: onDecrement) {
                ZStack {
                    Circle()
                        .fill(Color("colorPrimary"))
                        .frame(width: buttonSize, height: buttonSize)
                    
                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white)
                }
            }
            
            // Quantity text
            Text("\(quantity)")
                .font(.system(size: fontSize))  // Use the dynamic fontSize parameter
                .fontWeight(.semibold)  // Added to match headline style
                .frame(width: textWidth, alignment: .center)
            
            // Plus button
            Button(action: onIncrement) {
                ZStack {
                    Circle()
                        .fill(Color("colorPrimary"))
                        .frame(width: buttonSize, height: buttonSize)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(buttonSize / 2 + 6)
    }
}
