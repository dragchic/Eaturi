import SwiftUI
import WatchConnectivity
import AppIntents


class iOSSessionManager: NSObject, WCSessionDelegate {
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("ℹ️ sessionDidBecomeInactive called")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("ℹ️ sessionDidDeactivate called")
        WCSession.default.activate()
    }
    #endif
    
    static let shared = iOSSessionManager()

    func setup() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sendTopFoodsToWatch(_ foods: [SharedDefaultsManager.FoodItem]) {
        guard WCSession.default.isReachable else {
            print("⌛️ Watch not reachable")
            return
        }

        let foodDicts = foods.map { ["name": $0.name, "calories": $0.calories] }
        let message = ["topFoods": foodDicts]

        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Failed to send topFoods: \(error.localizedDescription)")
        })
    }
    
    func sendNutritionDataToWatch(healthManager: HealthManager) {
        guard WCSession.default.isReachable else {
            print("Watch not reachable for nutrition data")
            return
        }

        let message: [String: Any] = [
            "dailyCaloriesIntake": healthManager.dailyCaloriesIntake,
            "dailyProtein": healthManager.dailyProtein,
            "dailyFat": healthManager.dailyFat,
            "dailyCarbs": healthManager.dailyCarbs,
            "dailyCaloriesBurned": healthManager.dailyCaloriesBurned,
            "TDEE": healthManager.TDEE ?? 0
        ]

        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Failed to send nutrition data: \(error.localizedDescription)")
        })
    }
    
    func updateApplicationContext(with healthManager: HealthManager) {
        guard WCSession.default.activationState == .activated else {
            print("⛔️ WCSession not activated")
            return
        }

        let context: [String: Any] = [
            "topFoods": SharedDefaultsManager.fetchTopFoods().map { ["name": $0.name, "calories": $0.calories] },
            "dailyCaloriesIntake": healthManager.dailyCaloriesIntake,
            "dailyProtein": healthManager.dailyProtein,
            "dailyFat": healthManager.dailyFat,
            "dailyCarbs": healthManager.dailyCarbs,
            "dailyCaloriesBurned": healthManager.dailyCaloriesBurned,
            "TDEE": healthManager.TDEE ?? 0
        ]

        do {
            try WCSession.default.updateApplicationContext(context)
            print("Sent context to Watch: \(context)")
        } catch {
            print("❌ Failed to update context: \(error.localizedDescription)")
        }
    }


}

#if os(iOS)
struct NutritionIntake: View {
    @State private var selectedDate: Date = Date()
    @State private var navigationPath = NavigationPath()
    @State private var showProfileView = false
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                backgroundGradient
                VStack(spacing: 20) {
                    NutritionHeaderSection(
                        selectedDate: $selectedDate,
                        showProfileView: $showProfileView
                    )
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            NutritionOverview(selectedDate: selectedDate)
                            FoodHighestList(selectedDate: selectedDate)
                        }
                        .padding(.top, 0)
                        
                    }
                }
            }
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView(healthManager: healthManager) {
                healthManager.fetchAllHealthData()
                healthManager.calculateTDEE()
            }
        }
        .onAppear {
            healthManager.fetchAllHealthData()
            healthManager.calculateTDEE()
            iOSSessionManager.shared.setup()
            
            let foods = SharedDefaultsManager.fetchTopFoods()
                iOSSessionManager.shared.sendTopFoodsToWatch(foods)
            
            iOSSessionManager.shared.sendNutritionDataToWatch(healthManager: healthManager)
            
//            USING UpdateApplicationContext
            iOSSessionManager.shared.updateApplicationContext(with: healthManager)
        }
        .onChange(of: selectedDate) {
            healthManager.fetchDailyData(for: selectedDate)
        }
        
        .onChange(of: healthManager.dailyCaloriesIntake) {
            let foods = SharedDefaultsManager.fetchTopFoods()
            iOSSessionManager.shared.sendTopFoodsToWatch(foods)
            iOSSessionManager.shared.updateApplicationContext(with: healthManager)
        }

        .onChange(of: healthManager.height) { healthManager.calculateTDEE() }
        .onChange(of: healthManager.weight) { healthManager.calculateTDEE() }
        .onChange(of: healthManager.dateOfBirth) { healthManager.calculateTDEE() }
        .onChange(of: healthManager.biologicalSex) { healthManager.calculateTDEE() }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color("colorSecondary"), location: 0.0),
                .init(color: Color("colorSecondary").opacity(0.3), location: 0.3),
                .init(color: Color("abubg"), location: 0.6)
            ]),
            startPoint: .topTrailing,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    NutritionIntake()
        .environmentObject(HealthManager())
}
#endif
