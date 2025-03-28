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
   
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.title3)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Text("Rp\(item.price)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color("colorPrimary"))
                    HStack (spacing: 2){
                        Image("fire")
                            .resizable()
                            .frame(width: 15, height: 15)
//                            .border(.red)
                        Text("\(item.calories) kcal")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}

