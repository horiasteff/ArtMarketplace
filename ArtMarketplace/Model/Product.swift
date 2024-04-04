//
//  Product.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 05.03.2024.
//

import Foundation


struct Product: Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var image: URL
    var description: String
    var painter: String
    var price: Int
    var quantity: Int
}

extension Product {
    static var MOCK_PRODUCT = Product( id : UUID().uuidString, name: "Girl with a Pearl Earring", image: URL(string:"https://firebasestorage.googleapis.com/v0/b/artmarketplace-efb93.appspot.com/o/pictures%2FgirlWithPearlEarring.jpg?alt=media&token=4c80fae2-bdf2-4b53-9c63-41096f1e70a8")!, description: "Girl with a Pearl Earring is an oil painting by Dutch Golden Age painter Johannes Vermeer, dated c. 1665. Going by various names over the centuries, it became known by its present title towards the end of the 20th century after the earring worn by the girl portrayed there.", painter: "Picasso ", price: 1200, quantity: 1)
}
