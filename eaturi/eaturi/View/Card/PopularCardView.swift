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
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
                    .padding(10)
   
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.title3)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    HStack(spacing: 4) {
                        Image(systemName:"flame.fill")
                            .foregroundColor(.orange)
                        Text("\(item.calories) kcal")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    Text("Rp\(item.price)")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.colorPrimary)
                }
                .padding(.leading, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
