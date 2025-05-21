//
//  CalendarView.swift
//  HealthApp
//
//  Created by Grachia Uliari on 18/04/25.
//

import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    @State private var hasScrolled = false
    private let calendar = Calendar.current
    @State private var showDatePicker = false


    var body: some View {
        let weekDates = extendedDates(for: selectedDate)

        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(weekDates, id: \.self) { date in
                        VStack(spacing: 5) {
                            Text(shortDay(from: date))
                                .font(.caption)
                                .foregroundColor(.gray)

                            Text("\(calendar.component(.day, from: date))")
                                .font(.headline)
                                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                                .frame(width: 30, height: 30)
                                .background(calendar.isDate(date, inSameDayAs: selectedDate) ? Color("colorPrimary") : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedDate = date
                                }
                        }
                        .id(date)
                    }
                }
                .padding(.vertical, 10)
            }
            .onAppear {
                if !hasScrolled {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let index = weekDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: selectedDate) }) {
                            let scrollTarget = weekDates[index]
                            proxy.scrollTo(scrollTarget, anchor: .center)
                            hasScrolled = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("Select Date", selection: $selectedDate,
                               displayedComponents: [.date])
                        
                }
                datePickerStyle(.graphical)
                .padding()
                
                Button("Done") {
                    showDatePicker = false
                }
                .padding(.bottom, 20)
            }
            .presentationDetents([.medium])
        }
    }
        

    func shortDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    func extendedDates(for baseDate: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: baseDate),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate)) else {
            return []
        }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
}

