//
//  Transaction.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 25.03.2024.
//

import Foundation

struct Transaction: Decodable {
    var id: String
    var type: String
    var amount: Double
    var date: Date
}

extension Transaction {
    static var MOCK_TRANSACTION = Transaction(id: UUID().uuidString, type: "Add", amount: 500.50, date: Date())
}
