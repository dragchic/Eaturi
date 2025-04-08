//
//  FilterView.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct FilterView: View {
    var onSelectFilter: ([String]) -> Void
    var selectedFilters: [String]

    @State private var activeFilters: [String] = []

    let filters = ["Low Carb", "Low Calorie", "High Protein", "Low Fat", "High Fiber"]

    init(onSelectFilter: @escaping ([String]) -> Void, selectedFilters: [String]) {
        self.onSelectFilter = onSelectFilter
        self.selectedFilters = selectedFilters
        _activeFilters = State(initialValue: selectedFilters)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Filter Food")
                .font(.title)
                .fontWeight(.bold)
                .padding()


            HStack {
                ForEach(["Low Carb", "Low Calorie", "Low Fat"], id: \.self) { filter in
                    Button(action: {
                        toggleFilter(filter)
                    }) {
                        Text(filter)
                            .padding()
                            .frame(height: 50)
                            .background(activeFilters.contains(filter) ? .colorPrimary : Color.gray.opacity(0.1))
                            .foregroundColor(activeFilters.contains(filter) ? .white : .black)
                            .cornerRadius(30)
                    }
                }
            }

            HStack {
                ForEach(["High Protein", "High Fiber"], id: \.self) { filter in
                    Button(action: {
                        toggleFilter(filter)
                    }) {
                        Text(filter)
                            .padding()
                            .frame(height: 50)
                            .background(activeFilters.contains(filter) ? .colorPrimary : Color.gray.opacity(0.1))
                            .foregroundColor(activeFilters.contains(filter) ? .white : .black)
                            .cornerRadius(30)
                    }
                }
            }

            Spacer()

            HStack {
                Button(action: {
                    activeFilters.removeAll()
                    onSelectFilter([])
                }) {
                    Text("Clear")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(width: 130, height: 40)
                }

                Button(action: {
                    onSelectFilter(activeFilters)
                }) {
                    Text("Apply Filter")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color("colorPrimary"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .top)
        .background(Color.white)
        .cornerRadius(20)
        .presentationDetents([.height(300)])
    }
    
    private func toggleFilter(_ filter: String) {
        if activeFilters.contains(filter) {
            activeFilters.removeAll { $0 == filter }
        } else {
            activeFilters.append(filter)
        }
    }
}
