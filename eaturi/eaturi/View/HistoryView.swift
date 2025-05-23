import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HistoryRecord.timestamp, order: .reverse)
    private var historyRecords: [HistoryRecord]
    
    var onPickAgain: ([UUID: Int]) -> Void
    var body: some View {
       
        ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("colorSecondary"), location: 0.0),
                        .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                        .init(color: Color("abubg"), location: 0.6)
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    // Top header
                    HStack {
                        Text("History")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blackGray)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    
                    if historyRecords.isEmpty {
                        // Centered message when empty
                        Spacer()
                        Text("No history records found")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else {
                        // ScrollView of history
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(historyRecords) { record in
                                    HistoryCardView(record: record, onPickAgain: onPickAgain)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                modelContext.delete(record)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
                .padding(.horizontal)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 60)
                }
            }
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
