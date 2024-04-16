//
//  Entity.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 16.04.2024.
//

import Foundation

struct Entity: Decodable, Identifiable {
    var id: String
    var entityName: String
    var startDate: String
    var endDate: String
}

extension Entity {
    static var MOCK_ENTITY = Entity(id: UUID().uuidString, entityName: "Biblioteca Nationala", startDate: "March 31, 2024 at 11:36:36 PM UTC+3", endDate: "March 31, 2024 at 11:36:36 PM UTC+3")
}
