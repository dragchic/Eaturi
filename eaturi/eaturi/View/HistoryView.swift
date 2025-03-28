//
//  HistoryView.swift
//  KasturiFoodTracker
//
//  Created by Grachia Uliari on 18/03/25.
//
import SwiftUI

struct HistoryView: View {
    @Binding var products: [UUID: Int]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("colorSecondary"), location: 0.0),
                        .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                        .init(color: .white, location: 0.6)
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        HistoryCardView(products: products)
                        HistoryCardView(products: products)
                        HistoryCardView(products: products)
                        HistoryCardView(products: products)
                        HistoryCardView(products: products)
                    }
                }
                .padding()
                .navigationTitle("History")
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static let dummyProducts: [UUID: Int] = [
        UUID(): 1,
        UUID(): 2,
        UUID(): 1,
        UUID(): 3
    ]
    
    static var previews: some View {
        HistoryView(products: .constant(dummyProducts))
    }
}
