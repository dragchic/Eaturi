//
//  ShowTopFoodsIntent.swift
//  eaturi
//
//  Created by Grachia Uliari on 19/05/25.
//

import AppIntents

struct ShowTopFoodsIntent: AppIntent, ProvidesDialog {
    var value: Never?

    static var title: LocalizedStringResource = "Lihat Makanan Tertinggi Kalori"
    static var description = IntentDescription("Menampilkan daftar makanan dengan kalori tertinggi hari ini.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let topFoods = SharedDefaultsManager.fetchTopFoods()
        let names = topFoods.map { "\($0.name) - \($0.calories) kcal" }


        let formattedList = names.prefix(3).map {
            "• \($0)"
        }.joined(separator: "\n\n")

        _ = """
        Food Highest in Calories Today:
        \(formattedList)
        """

        return .result(dialog: IntentDialog("Food Highest in Calories Today:\n\(formattedList)"))

    }
}






//struct ShowTopFoodsIntent: AppIntent {
//    static var title: LocalizedStringResource = "Lihat Makanan Tertinggi Kalori"
//    static var description = IntentDescription("Menampilkan daftar makanan dengan kalori tertinggi hari ini.")
//
//    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
//        let topFoods = SharedDefaultsManager.fetchTopFoods()
//        let names = topFoods.map { "\($0.name) - \($0.calories) kcal" }
//
//        // Kirim ke Apple Watch juga
//        iOSSessionManager.shared.sendTopFoodsToWatch(topFoods)
//
//        return .result(
//            value: names, dialog: "Makanan tertinggi kalori berhasil diambil."
//        )
//    }
//}
