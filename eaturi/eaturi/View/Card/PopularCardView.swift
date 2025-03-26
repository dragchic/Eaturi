//
//  PopularCardView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct PopularCardView: View {
    @Binding var item: FoodModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .clipped()
                Spacer()
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
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    MainTabView()
}
