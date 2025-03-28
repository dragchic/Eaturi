import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State private var isExpanded = false
    @Binding var isFilterModalPresented: Bool
    @Binding var selectedFilters: [String]
    
    var body: some View {
        HStack(spacing: 12) {
            // Search Field with magnifying glass and clear button
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.gray)
                
                
                if !searchText.isEmpty {
                    Button(action: {
                        withAnimation {
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .transition(.opacity)
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            
            // Filter Icon with a subtle scale animation on tap
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFilterModalPresented.toggle()
                }
            }) {
                Image(systemName: "slider.horizontal.3")
                    .symbolVariant(.fill)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color("colorPrimary"))
            }
            .sheet(isPresented: $isFilterModalPresented) {
                FilterView(
                    onSelectFilter: { filters in
                        // Append new filters (or replace as needed)
                        self.selectedFilters = filters
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

#Preview {
    MainTabView()
}
