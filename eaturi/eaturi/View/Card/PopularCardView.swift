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
                    .padding(.leading, 10)
   
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .padding(.top, 5)
                    HStack(spacing: 4) {
                        Image(systemName:"flame.fill")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Text("\(item.calories) kcal")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                
                    HStack(spacing: 5) {
                        HStack(spacing: 2) {
                            Image(systemName: "circle.hexagongrid.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                            Text("\(item.fat)g")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 3) {
                            Image(systemName: "bolt.fill")
                                .font(.caption2)
                                .foregroundColor(.red)
                            Text("\(item.protein)g")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 3) {
                            Image(systemName:"chart.pie.fill")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            Text("\(item.carbs)g")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                }
                .padding(.leading, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return MainTabView(cartItems: [:])
            .modelContainer(previewer.container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
