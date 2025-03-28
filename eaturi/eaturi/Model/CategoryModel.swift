//
//  CategoryModel.swift
//  eaturi
//
//  Created by Grachia Uliari on 27/03/25.
//
import SwiftUI

struct CategoryModel: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var image: String
    var localName: String
    
    static func generateCategories() -> [CategoryModel] {
        return [
            CategoryModel(name: "Chicken", image: "chicken_thights", localName: "Ayam"),
            CategoryModel(name: "Rice", image: "Rice Bowl", localName: "Nasi"),
            CategoryModel(name: "Fish", image: "fish", localName: "Ikan"),
            CategoryModel(name: "Beef", image: "meat", localName: "Daging"),
            CategoryModel(name: "Egg", image: "egg", localName: "Telur"),
            CategoryModel(name: "Fried", image: "fried", localName: "Gorengan"),
            CategoryModel(name: "Veggies", image: "veggies", localName: "Sayuran"),
            CategoryModel(name: "Sambal", image: "sambal", localName: "Sambal"),
            CategoryModel(name: "Others", image: "others", localName: "Lainnya")
        ]
    }
}
