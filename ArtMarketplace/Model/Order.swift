//
//  Order.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 29.03.2024.
//

import Foundation

struct Order: Decodable {
    var id: String
    var type: String
    var date: Date
    var products: [Product]
    var totalPrice: Double
}

extension Order {
    static var MOCK_ORDER = Order(id: NSUUID().uuidString, type: "Kobe Bryant", date: Date(), products: [Product.MOCK_PRODUCT], totalPrice: 5000.0)
}
