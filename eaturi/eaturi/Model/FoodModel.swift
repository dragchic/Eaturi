import SwiftUI

struct FoodModel: Identifiable {
    let id: UUID
    let name: String
    let image: String
    let price: Int
    let calories: Int
    let protein: Int
    let carbs: Int
    let fiber: Int
    let fat: Int
    let isPopular: Bool
    let categories: [String]
    let availableDays: [String]
    let description: String

    static func sampleData() -> [FoodModel] {
        return [
            // MARK: - Ayam (6 items)
            FoodModel(
                id: UUID(), name: "Ayam Teriyaki", image: "ayam_teriyaki",
                price: 25000, calories: 350, protein: 30, carbs: 25, fiber: 2, fat: 15,
                isPopular: true, categories: ["Ayam"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Ayam panggang saus teriyaki"
            ),
            FoodModel(
                id: UUID(), name: "Ayam Bistik", image: "ayam_bistik",
                price: 27000, calories: 380, protein: 32, carbs: 20, fiber: 3, fat: 18,
                isPopular: true, categories: ["Ayam"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Ayam bistik saus jamur"
            ),
            FoodModel(
                id: UUID(), name: "Ayam Asam Manis", image: "ayam_asam_manis",
                price: 23000, calories: 320, protein: 28, carbs: 30, fiber: 2, fat: 12,
                isPopular: true, categories: ["Ayam"],
                availableDays: ["Senin", "Selasa", "Kamis"],
                description: "Ayam saus asam manis"
            ),
            FoodModel(
                id: UUID(), name: "Ayam Lada Hitam/Fillet", image: "ayam_lada",
                price: 28000, calories: 300, protein: 35, carbs: 15, fiber: 2, fat: 14,
                isPopular: true, categories: ["Ayam"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Ayam fillet lada hitam"
            ),
            FoodModel(
                id: UUID(), name: "Ayam Bakar", image: "ayam_bakar",
                price: 24000, calories: 380, protein: 34, carbs: 18, fiber: 3, fat: 20,
                isPopular: true, categories: ["Ayam"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Ayam bakar bumbu kecap"
            ),
            FoodModel(
                id: UUID(), name: "Ayam Goreng Serundeng", image: "ayam_serundeng",
                price: 22000, calories: 400, protein: 28, carbs: 22, fiber: 2, fat: 22,
                isPopular: true, categories: ["Ayam"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Ayam goreng dengan serundeng"
            ),

            // MARK: - Ikan (8 items)
            FoodModel(
                id: UUID(), name: "Ikan Cakalang Suwir", image: "cakalang_suwir",
                price: 20000, calories: 250, protein: 25, carbs: 10, fiber: 2, fat: 10,
                isPopular: false, categories: ["Ikan"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Ikan cakalang suwir pedas"
            ),
            FoodModel(
                id: UUID(), name: "Ikan Dori Asam Manis", image: "dori_asam",
                price: 28000, calories: 300, protein: 28, carbs: 25, fiber: 1, fat: 12,
                isPopular: true, categories: ["Ikan"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Ikan dori saus asam manis"
            ),
            FoodModel(
                id: UUID(), name: "Ikan Sarden Rica", image: "sarden_rica",
                price: 18000, calories: 280, protein: 20, carbs: 15, fiber: 2, fat: 15,
                isPopular: false, categories: ["Ikan"],
                availableDays: ["Selasa", "Kamis"],
                description: "Sarden pedas khas Manado"
            ),
            FoodModel(
                id: UUID(), name: "Ikan Tongkol Balado", image: "tongkol_balado",
                price: 17000, calories: 270, protein: 22, carbs: 12, fiber: 2, fat: 12,
                isPopular: true, categories: ["Ikan"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Ikan tongkol sambal balado"
            ),
            FoodModel(
                id: UUID(), name: "Cumi Cabe Hijau", image: "cumi_cabe",
                price: 30000, calories: 250, protein: 28, carbs: 10, fiber: 1, fat: 10,
                isPopular: true, categories: ["Ikan"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis"],
                description: "Cumi tumis cabe hijau"
            ),
            FoodModel(
                id: UUID(), name: "Kentang Balado", image: "kentang_balado",
                price: 12000, calories: 200, protein: 4, carbs: 30, fiber: 3, fat: 8,
                isPopular: false, categories: ["Lainnya"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Kentang goreng sambal balado"
            ),
            FoodModel(
                id: UUID(), name: "Otak-Otak Singapore Rica", image: "otak_rica",
                price: 15000, calories: 180, protein: 15, carbs: 8, fiber: 1, fat: 8,
                isPopular: true, categories: ["Ikan"],
                availableDays: ["Selasa", "Kamis"],
                description: "Otak-otak pedas ala Singapura"
            ),
            FoodModel(
                id: UUID(), name: "Sosis Oseng Bawang Cabe Rawit", image: "sosis_oseng",
                price: 15000, calories: 250, protein: 10, carbs: 15, fiber: 1, fat: 15,
                isPopular: true, categories: ["Lainnya"],
                availableDays: ["Selasa", "Kamis"],
                description: "Sosis tumis bawang cabe rawit"
            ),

            // MARK: - Telur (7 items)
            FoodModel(
                id: UUID(), name: "Telur Dadar Tipis", image: "telur_dadar",
                price: 8000, calories: 150, protein: 10, carbs: 2, fiber: 0, fat: 10,
                isPopular: false, categories: ["Telur"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Telur dadar tipis gurih"
            ),
            FoodModel(
                id: UUID(), name: "Telur Ceplok Balado", image: "ceplok_balado",
                price: 10000, calories: 180, protein: 12, carbs: 3, fiber: 1, fat: 12,
                isPopular: true, categories: ["Telur"],
                availableDays: ["Selasa", "Kamis"],
                description: "Telur ceplok sambal balado"
            ),
            FoodModel(
                id: UUID(), name: "Telur Ceplok Ponti Cabe Rawit", image: "ceplok_ponti",
                price: 12000, calories: 200, protein: 13, carbs: 5, fiber: 1, fat: 14,
                isPopular: true, categories: ["Telur"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Telur ceplok sambal ponti"
            ),
            FoodModel(
                id: UUID(), name: "Telur Bulat Balado", image: "telur_bulat",
                price: 10000, calories: 170, protein: 11, carbs: 4, fiber: 1, fat: 11,
                isPopular: true, categories: ["Telur"],
                availableDays: ["Selasa", "Kamis"],
                description: "Telur rebus sambal balado"
            ),
            FoodModel(
                id: UUID(), name: "Telur Puyuh Balado", image: "telur_puyuh",
                price: 12000, calories: 180, protein: 10, carbs: 5, fiber: 1, fat: 8,
                isPopular: true, categories: ["Telur"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Telur puyuh sambal balado"
            ),
            FoodModel(
                id: UUID(), name: "Telur Masak Semur", image: "telur_semur",
                price: 13000, calories: 220, protein: 14, carbs: 8, fiber: 1, fat: 12,
                isPopular: false, categories: ["Telur"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Telur rebus kuah semur"
            ),
            FoodModel(
                id: UUID(), name: "Tahu Masak Semur", image: "tahu_semur",
                price: 11000, calories: 150, protein: 9, carbs: 6, fiber: 1, fat: 8,
                isPopular: false, categories: ["Lainnya"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Tahu kuah semur manis"
            ),

            // MARK: - Sayuran (14 items)
            FoodModel(
                id: UUID(), name: "Sayur Sawi Putih", image: "sawi_putih",
                price: 8000, calories: 70, protein: 2, carbs: 8, fiber: 3, fat: 1,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Tumis sawi putih"
            ),
            FoodModel(
                id: UUID(), name: "Sayur Toge", image: "toge",
                price: 7000, calories: 60, protein: 3, carbs: 5, fiber: 2, fat: 1,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Selasa", "Kamis"],
                description: "Tumis toge wortel"
            ),
            FoodModel(
                id: UUID(), name: "Sayur Pok Coy", image: "pok_coy",
                price: 9000, calories: 65, protein: 2, carbs: 6, fiber: 2, fat: 1,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Tumis pok coy saus tiram"
            ),
            FoodModel(
                id: UUID(), name: "Sayur Krecek", image: "sayur_krecek",
                price: 10000, calories: 120, protein: 5, carbs: 10, fiber: 2, fat: 3,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Selasa", "Kamis"],
                description: "Sayur krecek khas Jogja"
            ),
            FoodModel(
                id: UUID(), name: "Sayur Pare Ikan Teri", image: "pare_teri",
                price: 9000, calories: 90, protein: 4, carbs: 8, fiber: 3, fat: 2,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Pare tumis ikan teri"
            ),
            FoodModel(
                id: UUID(), name: "Sayur Nangka", image: "sayur_nangka",
                price: 10000, calories: 110, protein: 3, carbs: 12, fiber: 4, fat: 1,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Selasa", "Kamis"],
                description: "Gudeg nangka muda"
            ),
            FoodModel(
                id: UUID(), name: "Sayur Labu", image: "sayur_labu",
                price: 9000, calories: 100, protein: 1, carbs: 12, fiber: 3, fat: 1,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Selasa", "Kamis"],
                description: "Labu siam tumis"
            ),

            // MARK: - Gorengan (6 items)
            FoodModel(
                id: UUID(), name: "Bakwan Jagung", image: "bakwan_jagung",
                price: 5000, calories: 150, protein: 3, carbs: 20, fiber: 2, fat: 8,
                isPopular: true, categories: ["Gorengan"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Bakwan jagung renyah"
            ),
            FoodModel(
                id: UUID(), name: "Martabak Telor", image: "martabak_telor",
                price: 12000, calories: 300, protein: 12, carbs: 25, fiber: 1, fat: 18,
                isPopular: true, categories: ["Gorengan"],
                availableDays: ["Selasa", "Kamis"],
                description: "Martabak telur isi daging"
            ),
            FoodModel(
                id: UUID(), name: "Bakwan Sayur", image: "bakwan_sayur",
                price: 5000, calories: 130, protein: 2, carbs: 18, fiber: 2, fat: 7,
                isPopular: true, categories: ["Gorengan"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Bakwan campur sayuran"
            ),

            // MARK: - Nasi (8 items)
            FoodModel(
                id: UUID(), name: "Nasi Putih 1 Porsi", image: "nasi_putih",
                price: 10000, calories: 200, protein: 4, carbs: 45, fiber: 1, fat: 1,
                isPopular: true, categories: ["Nasi"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Nasi putih pulen"
            ),
            FoodModel(
                id: UUID(), name: "Nasi Putih 1/2 Porsi", image: "nasi_putih_half",
                price: 6000, calories: 100, protein: 2, carbs: 22, fiber: 0, fat: 0,
                isPopular: true, categories: ["Nasi"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Nasi putih 1/2 porsi"
            ),
            FoodModel(
                id: UUID(), name: "Nasi Merah 1 Porsi", image: "nasi_merah",
                price: 12000, calories: 180, protein: 5, carbs: 40, fiber: 3, fat: 1,
                isPopular: true, categories: ["Nasi"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Nasi merah organik"
            ),
            FoodModel(
                id: UUID(), name: "Nasi Merah 1/2 Porsi", image: "nasi_merah_half",
                price: 7000, calories: 90, protein: 2, carbs: 20, fiber: 1, fat: 0,
                isPopular: true, categories: ["Nasi"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Nasi merah 1/2 porsi"
            ),

            // MARK: - Sambal (4 items)
            FoodModel(
                id: UUID(), name: "Sambal Merah", image: "sambal_merah",
                price: 3000, calories: 50, protein: 1, carbs: 5, fiber: 1, fat: 3,
                isPopular: true, categories: ["Sambal"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Sambal merah pedas"
            ),
            FoodModel(
                id: UUID(), name: "Sambal Dabu-dabu", image: "sambal_dabu",
                price: 4000, calories: 45, protein: 1, carbs: 4, fiber: 1, fat: 2,
                isPopular: true, categories: ["Sambal"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Sambal khas Manado"
            ),
            FoodModel(
                id: UUID(), name: "Sambal Hijau", image: "sambal_hijau",
                price: 4000, calories: 55, protein: 1, carbs: 6, fiber: 1, fat: 3,
                isPopular: true, categories: ["Sambal"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Sambal hijau khas Padang"
            ),

            // MARK: - Lainnya (15 items)
            FoodModel(
                id: UUID(), name: "Mie Goreng Telor", image: "mie_telor",
                price: 18000, calories: 350, protein: 12, carbs: 45, fiber: 2, fat: 15,
                isPopular: true, categories: ["Mie"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Mie goreng dengan telur"
            ),
            FoodModel(
                id: UUID(), name: "Orek Tempe Balado", image: "tempe_balado",
                price: 10000, calories: 200, protein: 12, carbs: 15, fiber: 3, fat: 8,
                isPopular: false, categories: ["Lainnya"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Tempe orek sambal balado"
            ),
            FoodModel(
                id: UUID(), name: "Sapi Lada Hitam", image: "sapi_lada",
                price: 35000, calories: 420, protein: 38, carbs: 25, fiber: 2, fat: 25,
                isPopular: true, categories: ["Daging"],
                availableDays: ["Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Daging sapi lada hitam"
            ),
            // MARK: - Lainnya (Lanjutan)
            FoodModel(
                id: UUID(), name: "Mie Goreng Special", image: "mie_special",
                price: 20000, calories: 380, protein: 15, carbs: 50, fiber: 3, fat: 18,
                isPopular: true, categories: ["Mie"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Mie goreng dengan tambahan seafood"
            ),
            FoodModel(
                id: UUID(), name: "Tahu Crispy", image: "tahu_crispy",
                price: 8000, calories: 120, protein: 8, carbs: 10, fiber: 1, fat: 6,
                isPopular: true, categories: ["Gorengan"],
                availableDays: ["Selasa", "Kamis"],
                description: "Tahu goreng tepung krispi"
            ),
            FoodModel(
                id: UUID(), name: "Sop Buntut", image: "sop_buntut",
                price: 35000, calories: 280, protein: 25, carbs: 15, fiber: 2, fat: 12,
                isPopular: false, categories: ["Lainnya"],
                availableDays: ["Jumat"],
                description: "Sop buntut dengan kuah kaldu sapi"
            ),
            FoodModel(
                id: UUID(), name: "Krengsengan Kambing", image: "krengsengan",
                price: 40000, calories: 450, protein: 40, carbs: 20, fiber: 2, fat: 28,
                isPopular: true, categories: ["Daging"],
                availableDays: ["Rabu", "Jumat"],
                description: "Daging kambing bumbu krengsengan"
            ),
            FoodModel(
                id: UUID(), name: "Cap Cay Kuah", image: "capcay",
                price: 18000, calories: 220, protein: 12, carbs: 25, fiber: 4, fat: 10,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Senin", "Kamis"],
                description: "Cap cay mix sayuran dengan kuah"
            ),
            FoodModel(
                id: UUID(), name: "Pindang Tulang", image: "pindang",
                price: 22000, calories: 300, protein: 28, carbs: 12, fiber: 2, fat: 15,
                isPopular: false, categories: ["Ikan"],
                availableDays: ["Selasa", "Kamis"],
                description: "Ikan pindang kuah kuning"
            ),
            FoodModel(
                id: UUID(), name: "Kerupuk Udang", image: "kerupuk",
                price: 5000, calories: 100, protein: 2, carbs: 15, fiber: 0, fat: 5,
                isPopular: true, categories: ["Gorengan"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Kerupuk udang renyah"
            ),
            FoodModel(
                id: UUID(), name: "Tumis Kacang Panjang", image: "kacang_panjang",
                price: 9000, calories: 80, protein: 3, carbs: 8, fiber: 3, fat: 2,
                isPopular: false, categories: ["Sayuran"],
                availableDays: ["Selasa", "Kamis"],
                description: "Tumis kacang panjang bawang putih"
            ),
            FoodModel(
                id: UUID(), name: "Rendang Telur", image: "rendang_telur",
                price: 15000, calories: 250, protein: 14, carbs: 10, fiber: 2, fat: 15,
                isPopular: true, categories: ["Telur"],
                availableDays: ["Jumat"],
                description: "Telur rendang bumbu Padang"
            ),
            FoodModel(
                id: UUID(), name: "Sate Usus", image: "sate_usus",
                price: 12000, calories: 180, protein: 15, carbs: 5, fiber: 0, fat: 10,
                isPopular: false, categories: ["Lainnya"],
                availableDays: ["Rabu"],
                description: "Sate usus ayam bumbu kacang"
            ),
            FoodModel(
                id: UUID(), name: "Jus Jambu", image: "jus_jambu",
                price: 10000, calories: 120, protein: 1, carbs: 28, fiber: 2, fat: 0,
                isPopular: true, categories: ["Minuman"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Jus jambu merah segar"
            ),
            FoodModel(
                id: UUID(), name: "Es Teh Manis", image: "es_teh",
                price: 5000, calories: 50, protein: 0, carbs: 12, fiber: 0, fat: 0,
                isPopular: true, categories: ["Minuman"],
                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],
                description: "Es teh manis segar"
            ),
            FoodModel(
                id: UUID(), name: "Kopi Susu", image: "kopi_susu",
                price: 8000, calories: 80, protein: 2, carbs: 10, fiber: 0, fat: 3,
                isPopular: true, categories: ["Minuman"],
                availableDays: ["Senin", "Rabu", "Jumat"],
                description: "Kopi susu gula aren"
            )
        ]
    }
}
