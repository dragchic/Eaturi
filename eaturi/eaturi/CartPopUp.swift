//
//  CartPopUp.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct CartPopUp: View {
    var totalCalories: Int
    var totalPrice: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your picked food")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Total Calories: \(totalCalories)")
                .foregroundStyle(.white)
                .font(.caption)
            Text("Total Price: Rp\(totalPrice)")
                .foregroundStyle(.white)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.9))
        .cornerRadius(15)
        .padding(.horizontal)
        Spacer()
    }
}
