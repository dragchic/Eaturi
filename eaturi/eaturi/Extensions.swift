//
//  Extensions.swift
//  eaturi
//
//  Created by Grachia Uliari on 27/03/25.
//
import SwiftUI

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
