//
//  EaturiIntents.swift
//  EaturiIntents
//
//  Created by Grachia Uliari on 19/05/25.
//

import AppIntents

struct EaturiIntents: AppIntent {
    static var title: LocalizedStringResource { "EaturiIntents" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
