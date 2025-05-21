//
//  NutritionBox.swift
//  eaturi
//
//  Created by Grachia Uliari on 11/05/25.
//
import SwiftUI

struct NutritionBox: View {
    var title: String
    var value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .fontWeight(.light)
                .foregroundColor(Color("BlackGray"))
            Text("\(value)")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("BlackGray"))
            Text("Kcal")
                .font(.system(size: 13, weight: .light))
                .foregroundColor(.gray)
        }
        .frame(width: 150, height: 79, alignment: .leading)
        .padding(.leading, 10)
        .background(Color.white)
        .cornerRadius(10)
    }
}


struct MacroProgress: View {
    var name: String
    var current: Double
    var total: Double
    
    @State private var animatedValue: Double = 0
    @State private var animatedLabel: Double = 0
    
    var safeCurrent: Double {
        max(0, current)
    }
    
    
    var barColor: Color {
        switch name.lowercased() {
        case "protein":
            return Color("neon")
        case "fat":
            return Color("neon")
        case "carbs":
            return Color("neon")
        default:
            return Color("colorPrimary")
        }
    }
    
    
    var body: some View {
#if os(iOS)
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.system(size: 14))
                    .foregroundColor(Color("BlackGray"))
                Spacer()
                Text("\(Int(max(animatedLabel, 0)))/\(Int(max(total, 1)))g")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: max(animatedValue, 0), total: max(total, 1))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("colorPrimary")))
                .frame(height: 6)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(3)
                .onAppear {
                    animateToCurrent()
                }
                .onChange(of: current) {
                    animateToCurrent()
                }
        }
        
#else
        VStack(alignment: .leading, spacing: 4) {
            VStack (alignment: .leading){
                Text(name)
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white.opacity(0.8))
                
                ProgressView(value: current, total: total)
                    .progressViewStyle(LinearProgressViewStyle(tint: barColor))
                    .frame(height: 6)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(3)
                
                Text("\(Int(current))/\(Int(total))g")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            
        }
#endif
    }
    
    private func animateToCurrent() {
        withAnimation(.easeOut(duration: 1.0)) {
            animatedValue = current
        }
        
        let steps = 30
        let stepDuration = 1.0 / Double(steps)
        let delta = (current - animatedLabel) / Double(steps)
        
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (stepDuration * Double(i))) {
                self.animatedLabel = min(current, self.animatedLabel + delta)
            }
        }
    }
    
    
}

//#Preview {
//    HStack(spacing: 12) {
//            MacroProgress(name: "Protein", current: 25, total: 50)
//            MacroProgress(name: "Fat", current: 15, total: 60)
//            MacroProgress(name: "Carbs", current: 80, total: 150)
//        }
//        .padding()
//        .previewLayout(.sizeThatFits)
//        .background(Color.black)
//}

