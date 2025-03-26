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
                    .foregroundColor(.black)
                TextField("What do you want to eat?", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.black)
                
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
            .background(Color.gray.opacity(0.1))
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
                    .foregroundColor(.black)
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
