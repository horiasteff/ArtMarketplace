//
//  Order.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 29.03.2024.
//

import Foundation

struct Order: Decodable {
    var id: String
    var name: String
    var type: String
    var date: Date
    var address: String
    var phone: String
    var products: [Product]
    var totalPrice: Double
}

extension Order {
    static var MOCK_ORDER = Order(id: NSUUID().uuidString, name: "Theodor Amann", type: "Card", date: Date(), address: "Adresa", phone: "+40722123123", products: [Product.MOCK_PRODUCT], totalPrice: 5000.0)
}
