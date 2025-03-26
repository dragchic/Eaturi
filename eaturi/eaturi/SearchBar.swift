//
//  SearchBar.swift
//  eaturi
//
//  Created by Raphael Gregorius on 26/03/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State private var isExpanded = false
    @Binding var isFilterModalPresented: Bool
    @Binding var selectedFilters: [String]
    
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.black)
                TextField("What do you want to eat?", text: $searchText)
                    .onChange(of: searchText) { _ in
                        // UI update
                    }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // FILTER ICON
            Image(systemName: "slider.horizontal.3")
                .symbolVariant(.fill)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color.black)
                .onTapGesture {
                    isFilterModalPresented.toggle()
                }
                .sheet(isPresented: $isFilterModalPresented) {
                    FilterView(
                        onSelectFilter: { selectedFilters in
                            self.selectedFilters = selectedFilters
                            isFilterModalPresented = false
                        },
                        selectedFilters: selectedFilters
                    )
                }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
