//
//  ProductManager.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 12.03.2024.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine

class ProductManager: ObservableObject {
    private var db = Firestore.firestore()

    @Published var productList =  [Product]()
    @Published var userCarts: [String: [Product]] = [:]
    @Published var total: Int = 0
    

    init() {
        fetchData()
        fetchUserCarts()
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
                
                return Product(id: UUID().uuidString, name: name, image: image, description: description, painter: painter, price: price)
                
            }
            
        }
    }
    
    func addToCart(product: Product) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let userCartRef = db.collection("users").document(currentUser.uid).collection("cart")
        let cartItemRef = userCartRef.document(product.id)
        let imageURLString = product.image.absoluteString

        // Example of product data you might want to store
        let data: [String: Any] = [
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "painter": product.painter,
            "image" : imageURLString,
            "id" : product.id
            // Add more product details as needed
        ]

        cartItemRef.setData(data) { error in
            if let error = error {
                print("Error adding product to cart: \(error)")
            } else {
                print("Product added to cart successfully")
                self.total += product.price
            }
        }
    }
    
    func removeFromCart(product: Product) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let userCartRef = db.collection("users").document(currentUser.uid).collection("cart")
        let cartItemRef = userCartRef.document(product.id)

        cartItemRef.delete { error in
            if let error = error {
                print("Error removing product from cart: \(error)")
            } else {
                print("Product removed from cart successfully")
                // Optionally, update local cart data or UI after removal
                if let index = self.userCarts[currentUser.uid]?.firstIndex(where: { $0.id == product.id }) {
                               self.userCarts[currentUser.uid]?.remove(at: index)
                           }
                self.fetchUserCarts()
                self.total -= product.price
            }
        }
    }
    
    func fetchUserCarts() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        let userCartRef = db.collection("users").document(currentUser.uid).collection("cart")
        userCartRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching user cart data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var userCart: [Product] = []
            for document in snapshot.documents {
                if let product = document.data() as? [String: Any] {
                    // Convert Firestore data to Product object
                    // Assuming you have a method to convert Firestore data to Product
                    let convertedProduct = self.convertFirestoreDataToProduct(product)
                    userCart.append(convertedProduct)
                }
            }
            // Update userCarts dictionary with user-specific cart data
            self.userCarts[currentUser.uid] = userCart
        }
    }

    // Function to convert Firestore data to Product object
    func convertFirestoreDataToProduct(_ data: [String: Any]) -> Product {
        // Extract product data from Firestore document
        guard let name = data["name"] as? String,
              let description = data["description"] as? String,
              let price = data["price"] as? Int,
              let imageURLString = data["image"] as? String,
              let imageURL = URL(string: imageURLString),
              let painter = data["painter"] as? String
        else {
            fatalError("Failed to extract product data from Firestore document")
        }

        // Initialize and return Product instance
        return Product(id: UUID().uuidString, name: name, image: imageURL, description: description, painter: painter, price: price)
    }
}
