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
