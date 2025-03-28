//
//  HistoryView.swift
//  KasturiFoodTracker
//
import SwiftUI

struct HistoryView: View {
    @Binding var historyRecords: [HistoryRecord] // Change to array of HistoryRecord
    
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
                .ignoresSafeArea(edges: .top)
                VStack {
                    ScrollView {
                        ForEach(historyRecords) { record in
                            HistoryCardView(record: record)
                        }
                    }
                }
                .padding()
                .navigationTitle("History")
            }
        }
    }
}
//
//struct HistoryView_Previews: PreviewProvider {
//    static let dummyRecords: [HistoryRecord] = [
//        HistoryRecord(
//            date: Date(),
//            cart: [UUID(): 1, UUID(): 2],
//            totalPrice: 150000,
//            totalCalories: 2000,
//            totalProtein: 50,
//            totalCarbs: 100,
//            totalFiber: 20,
//            totalFat: 30
//        ),
//        HistoryRecord(
//            date: Date().addingTimeInterval(-86400), // Yesterday
//            cart: [UUID(): 1, UUID(): 3],
//            totalPrice: 200000,
//            totalCalories: 2500,
//            totalProtein: 60,
//            totalCarbs: 120,
//            totalFiber: 25,
//            totalFat: 35
//        )
//    ]
//    
//    static var previews: some View {
//        HistoryView(historyRecords: .constant(dummyRecords))
//    }
//}
