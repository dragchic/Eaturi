//
//  ProfileView.swift
//  eaturi
//
//  Created by Grachia Uliari on 04/05/25.
//

// PATCHED ProfileView.swift
import SwiftUI
import HealthKit

struct ProfileView: View {
    @ObservedObject var healthManager: HealthManager
    @Environment(\.dismiss) var dismiss

    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Profile Summary")) {
                    // Date of Birth & Age
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        if let dob = healthManager.dateOfBirth {
                            Text(dateFormatter.string(from: dob))
                        } else {
                            Text("-").foregroundColor(.gray)
                        }
                    }

                    HStack {
                        Text("Age")
                        Spacer()
                        if let dob = healthManager.dateOfBirth {
                            Text("\(calculateAge(from: dob)) years")
                        } else {
                            Text("-").foregroundColor(.gray)
                        }
                    }

                    // Biological Sex
                    HStack {
                        Text("Biological Sex")
                        Spacer()
                        Text(biologicalSexLabel(healthManager.biologicalSex))
                    }

                    // Height
                    HStack {
                        Text("Height")
                        Spacer()
                        if let height = healthManager.height {
                            Text(String(format: "%.1f cm", height))
                        } else {
                            Text("-").foregroundColor(.gray)
                        }
                    }

                    // Weight
                    HStack {
                        Text("Weight")
                        Spacer()
                        if let weight = healthManager.weight {
                            Text(String(format: "%.1f kg", weight))
                        } else {
                            Text("-").foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Your Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                        onSave()
                    }) {
                        Text("Close")
                            .foregroundColor(Color("colorPrimary"))
                    }
                }

            }
        }
    }

    // MARK: - Helpers
    private func calculateAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        return ageComponents.year ?? 0
    }

    private func biologicalSexLabel(_ sex: HKBiologicalSex?) -> String {
        switch sex {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        default:
            return "-"
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
