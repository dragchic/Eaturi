//
//  QuantityControl.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct QuantityControl: View {
    @Binding var quantity: Int
    var onZeroQuantity: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                if quantity > 1 {
                    quantity -= 1
                } else{
                    onZeroQuantity()
                }
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Text("\(quantity)")
                .font(.headline)
                .frame(width: 30)
            
            Button(action: {
                quantity += 1
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(5)
    }
}
