import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HistoryRecord.timestamp, order: .reverse)
    private var historyRecords: [HistoryRecord]
    
    var onPickAgain: ([UUID: Int]) -> Void
    var body: some View {
        NavigationStack {
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
                VStack {
                    if historyRecords.isEmpty {
                        Text("No history records found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
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
                    }
                }
                .padding()
                .navigationTitle("History")
            }
        }
    }
}
