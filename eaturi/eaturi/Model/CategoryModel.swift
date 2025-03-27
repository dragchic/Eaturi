//
//  CategoryModel.swift
//  eaturi
//
//  Created by Grachia Uliari on 27/03/25.
//
import SwiftUI

struct CategoryModel: Identifiable {
    let id = UUID()
    var name: String
    var image: String
    
    static func generateCategories() -> [CategoryModel] {
        return [
            CategoryModel(name: "Chicken", image: "chicken_thights"),
            CategoryModel(name: "Rice", image: "Rice Bowl"),
            CategoryModel(name: "Fish", image: "fish"),
            CategoryModel(name: "Beef", image: "meat"),
            CategoryModel(name: "Egg", image: "egg"),
            CategoryModel(name: "Fried", image: "fried"),
            CategoryModel(name: "Veggies", image: "veggies"),
            CategoryModel(name: "Sambal", image: "sambal"),
            CategoryModel(name: "Others", image: "others"),
        ]
    }
}

