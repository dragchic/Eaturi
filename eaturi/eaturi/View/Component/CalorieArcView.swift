import SwiftUI

struct CalorieArcView: View {
    var totalTarget: Int
    var consumed: Int
    var burned: Int
    
    @State private var animatedProgress: CGFloat = 0
    @State private var animatedCalories: Int = 0
    
    var remainingCalories: Int {
        max(0, totalTarget - consumed + burned)
    }
    
    var progress: CGFloat {
        let effectiveTarget = max(1, totalTarget + burned)
        let ratio = Double(consumed) / Double(effectiveTarget)
        return min(1.0, ratio)
    }
    
    var body: some View {
#if os(watchOS)
        ZStack {
            // Neon shadow base glow
            Circle()
                .trim(from: 0.125, to: 0.875)
                .stroke(Color("neon").opacity(0.25),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(90))
                .blur(radius: 4)
            
            // Background ring
            Circle()
                .trim(from: 0.125, to: 0.875)
                .stroke(Color.gray.opacity(0.35),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(90))
            
            // Foreground progress with glow
            Circle()
                .trim(from: 0.125, to: 0.125 + (0.75 * progress))
                .stroke(remainingCalories == 0 ? Color("newRed") : Color("neon"),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(90))
                .shadow(color: (remainingCalories == 0 ? Color("newRed") : Color("neon")).opacity(0.7), radius: 5)
            
            // Neon text
            VStack(spacing: 2) {
                Text("\(remainingCalories)")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                
                
                Text("kCal left")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: Color("neon").opacity(0.6), radius: 2)
            }
        }
        .frame(width: 100, height: 100)
#else
        // iOS version
        ZStack {
            Circle()
                .trim(from: 0.125, to: 0.875)
                .stroke(Color.gray.opacity(0.2),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(90))
            
            Circle()
                .trim(from: 0.125, to: 0.125 + (0.75 * animatedProgress))
                .stroke(Color("colorPrimary"),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(90))
                .animation(.easeOut(duration: 1.0), value: animatedProgress)
            
            VStack(spacing: 2) {
                Text("\(remainingCalories)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("BlackGray"))
                Text("Kcal Left")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 140, height: 140)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = progress
            }
            animateCalories(to: remainingCalories)
        }
        .onChange(of: consumed) {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = progress
            }
            animateCalories(to: remainingCalories)
        }
        
#endif
    }
    
    
    private func animateCalories(to value: Int) {
        let duration: Double = 1.0
        let steps = 30
        let stepDuration = duration / Double(steps)
        let delta = Double(value - animatedCalories) / Double(steps)
        
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (stepDuration * Double(i))) {
                self.animatedCalories = Int(Double(self.animatedCalories) + delta)
            }
        }
    }
    
}


#Preview {
    CalorieArcView(totalTarget: 1600, consumed: 1000, burned: 140)
}
