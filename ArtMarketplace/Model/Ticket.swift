//
//  Ticket.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 29.04.2024.
//

import Foundation

struct Ticket: Decodable, Identifiable {
    let id: String 
    let entityName: String
    let price: Double
}

extension Ticket {
    static var MOCK_TICKET = Ticket(id: NSUUID().uuidString, entityName: Entity.MOCK_ENTITY.entityName, price: 25.0)
}
