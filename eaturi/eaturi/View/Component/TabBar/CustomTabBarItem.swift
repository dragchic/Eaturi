//
//  CustomTabBarItem.swift
//  eaturi
//
//  Created by Raphael Gregorius on 08/04/25.
//

import SwiftUI

struct CustomTabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Rectangle()
                .fill(isSelected ? color : Color.clear)
                .frame(height: 5)
                .cornerRadius(16)
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(isSelected ? color : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? color : .gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
