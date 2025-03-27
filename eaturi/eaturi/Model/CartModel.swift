//
//  CartModel.swift
//  eaturi
//
//  Created by Raphael Gregorius on 27/03/25.
//

import Foundation

struct CartModel {
    var id = UUID()
    var cartItems: [UUID: Int]
}
