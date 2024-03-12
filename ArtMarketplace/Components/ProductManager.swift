//
//  ProductManager.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 12.03.2024.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class ProductManager: ObservableObject {
    private var db = Firestore.firestore()

    @Published var productList =  [Product]()
    

    init() {
        fetchData()
    }

    func fetchData() {
        
        db.collection("pictures").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.productList = documents.map{ (queryDocumentSnapshot) -> Product in
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let imageUrlString = data["image"] as? String ?? ""
                let image = URL(string: imageUrlString) ?? URL(string: "https://placeholder-url.com")!
                let painter = data["painter"] as? String ?? ""
                let price = data["price"] as? Int ?? 0
                
                return Product(name: name, image: image, description: description, painter: painter, price: price)
                
            }
            
        }
    }
}
