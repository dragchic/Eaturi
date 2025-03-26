//
//  PopularCardView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct PopularCardView: View {
    @Binding var item: PopularMenu
    var body: some View {
        Image(item.image)
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        VStack(alignment: .leading, spacing: 5) {
            Text(item.name)
                .font(.headline)
                .fontWeight(.medium)
                .lineLimit(1)
            Text(item.price)
                .font(.subheadline)
                .foregroundColor(.red)
            Text("Calories: \(item.calories)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
        .padding(.leading, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
