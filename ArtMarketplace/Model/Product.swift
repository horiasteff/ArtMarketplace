//
//  Product.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 05.03.2024.
//

import Foundation


struct Product: Identifiable, Decodable {
    var id: String
    var name: String
    var image: URL
    var description: String
    var painter: String
    var price: Int
    var quantity: Int
}

var productList = [
    Product( id : UUID().uuidString, name: "Picasso 1",
         image: URL(string:"https://firebasestorage.googleapis.com/v0/b/artmarketplace-efb93.appspot.com/o/pictures%2FThe-Tree-Of-Life%20-%20G.%20Klimt.jpeg?alt=media&token=8ead0425-a4a6-4b53-a17d-5d251bac93e0")!,
         description: "First description", painter: "Picasso ", price: 1200, quantity: 1),
Product( id : UUID().uuidString, name: "Picasso 2", image: URL(string:"https://firebasestorage.googleapis.com/v0/b/artmarketplace-efb93.appspot.com/o/pictures%2FThe-Tree-Of-Life%20-%20G.%20Klimt.jpeg?alt=media&token=8ead0425-a4a6-4b53-a17d-5d251bac93e0")!, description: "First description", painter: "Picasso ", price: 1200, quantity: 1)
]
//    Product( name: "Picasso 2", image: "picasso2", description: "Second description", painter: "Picasso ", price: 1800),
//    Product( name: "Picasso 3", image: "picasso3", description: "Third description", painter: "Picasso ", price: 1900)

