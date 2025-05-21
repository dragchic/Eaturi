//
//  NutritionHeaderSection.swift
//  eaturi
//
//  Created by Grachia Uliari on 11/05/25.
//

import SwiftUI

struct NutritionHeaderSection: View {
    @Binding var selectedDate: Date
    @Binding var showProfileView: Bool
    @State private var showDatePicker = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("My Nutritions")
                    .font(.system(.largeTitle, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(Color("BlackGray"))
                
                Spacer()
                
                Button {
                    showProfileView = true
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(Color("colorPrimary"))
                }
            }
            .padding(.top, 70)
            .padding(.horizontal, 25)
            
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, 20)
//            .padding(.vertical, 8)
//            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 1)
            .tint(Color("colorPrimary"))

            
            
            
            WeekCalendarView(selectedDate: $selectedDate)
                .padding(.horizontal, 25)
        }
    }
}
