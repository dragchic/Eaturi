//
//  FoodDetailView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct FoodDetailView: View {
    let item: FoodModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .frame(maxWidth: 320, maxHeight: 260)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 10)
            Text(item.name)
                .font(.title2)
                .fontWeight(.bold)
            Text("Harga: \(item.price)")
                .font(.headline)
                .foregroundColor(.orange)
                .padding(.top, 4)
            
            Text("Nutrition")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            HStack{
                VStack{
                    Text("Calories")
                        .font(.caption)
                    Text("\(item.calories)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Protein")
                        .font(.caption)
                    Text("\(item.protein)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Fiber")
                        .font(.caption)
                    Text("\(item.fiber)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Fat")
                        .font(.caption)
                    Text("\(item.fat)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
                VStack{
                    Text("Carbs")
                        .font(.caption)
                    Text("\(item.carbs)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .frame(width: 70, height: 100)
            }
            Button {
                
            } label: {
                Text("Add to MyLunch")
                   .font(.headline)
                   .foregroundColor(.white)
                   .padding()
                   .frame(maxWidth: .infinity) // Allows the button to expand
                   .background(Color.colorPrimary)
                   .cornerRadius(.infinity)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7) // 80% of the screen width
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .presentationDetents([.height(500)])
    }
}

#Preview {
    FoodDetailView(
        item: FoodModel(
            name: "Ayam Goreng Asam Manis",
            image: "ayam_asam_manis",
            price: "25000",
            calories: "200",
            protein: "30",
            carbs: "10",
            fiber: "30",
            fat: "10",
            isPopular: true,
            categories: ["Ayam", "Bahan Asam Manis"]
        ),
        isPresented: .constant(true)
    )
}
