//
//  EaturiIntentsExtension.swift
//  EaturiIntents
//
//  Created by Grachia Uliari on 19/05/25.
//

import AppIntents

@main
struct EaturiIntentsExtension: AppIntentsExtension {
    static var intentTypes: [any AppIntent.Type] {
        [
            ShowTopFoodsIntent.self,
            RemainingCaloriesIntent.self
        ]
    }
}
