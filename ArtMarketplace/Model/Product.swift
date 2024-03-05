//
//  Product.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 05.03.2024.
//

import Foundation

struct Product: Identifiable {
    var id =  UUID()
    var name: String
    var image: String
    var description: String
    var painter: String
    var price: Int
}

var productList = [
    Product( name: "Picasso 1", image: "picasso1", description: "First description", painter: "Picasso ", price: 1200),
    Product( name: "Picasso 2", image: "picasso2", description: "Second description", painter: "Picasso ", price: 1800),
    Product( name: "Picasso 3", image: "picasso3", description: "Third description", painter: "Picasso ", price: 1900)
]
