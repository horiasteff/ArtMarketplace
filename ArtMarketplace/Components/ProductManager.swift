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
        self.$userCarts
            .map { carts in
                var totalPrice = 0
                
                for cart in carts.values {
                    for item in cart {
                        totalPrice += item.price * Int(item.quantity)
                    }
                }
                
                return totalPrice
            }
            .assign(to: &$total)
    }

    func fetchData() {
        
        db.collection("pictures").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.productList = documents.map{ (queryDocumentSnapshot) -> Product in
                let data = queryDocumentSnapshot.data()
                
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let imageUrlString = data["image"] as? String ?? ""
                let image = URL(string: imageUrlString) ?? URL(string: "https://placeholder-url.com")!
                let painter = data["painter"] as? String ?? ""
                let price = data["price"] as? Int ?? 0
                let quantity = data["quantity"] as? Int ?? 0
                
                return Product(id: id, name: name, image: image, description: description, painter: painter, price: price, quantity: quantity)
            }
            
        }
    }
    
    func addToCart(product: Product, documentID: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let userCartRef = db.collection("users").document(currentUser.uid).collection("cart")
        let cartItemRef = userCartRef.document(documentID)
        let imageURLString = product.image.absoluteString

        cartItemRef.getDocument { document, error in
            if let document = document, document.exists {
                let existingQuantity = document.data()?["quantity"] as? Int ?? 0
                let newQuantity = existingQuantity + 1
                cartItemRef.setData(["quantity": newQuantity], merge: true) { error in
                    if let error = error {
                        print("Error updating quantity in cart: \(error)")
                    } else {
                        print("Quantity updated in cart successfully")
                    }
                }
            } else {
                let data: [String: Any] = [
                    "id": documentID,
                    "name": product.name,
                    "description": product.description,
                    "price": product.price,
                    "painter": product.painter,
                    "image": imageURLString,
                    "quantity": 1
                ]

                cartItemRef.setData(data) { error in
                    if let error = error {
                        print("Error adding product to cart: \(error)")
                    } else {
                        print("Product added to cart successfully")
                    }
                }
            }
        }
    }
    
    
    func removeFromCart(product: Product) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        guard var userCart = self.userCarts[currentUser.uid] else {
            print("User's cart is empty or not loaded")
            return
        }

        if let index = userCart.firstIndex(where: { $0.id == product.id }) {
            let quantity = userCart[index].quantity

            if quantity > 1 {
                userCart[index].quantity -= 1
            } else {
                userCart.remove(at: index)
            }
            
            self.userCarts[currentUser.uid] = userCart

            let db = Firestore.firestore()
            let userCartRef = db.collection("users").document(currentUser.uid).collection("cart")
            let cartItemRef = userCartRef.document(product.id)

            if quantity > 1 {
                cartItemRef.setData(["quantity": userCart[index].quantity], merge: true) { error in
                    if let error = error {
                        print("Error updating quantity in cart: \(error)")
                    } else {
                        print("Quantity updated in cart successfully")
                    }
                }
            } else {
                cartItemRef.delete { error in
                    if let error = error {
                        print("Error removing product from cart: \(error)")
                    } else {
                        print("Product removed from cart successfully")
                        self.fetchUserCarts()
                    }
                }
            }
        } else {
            print("Product not found in user's cart")
        }
    }
    
    
    func deleteProductFromCart(product: Product) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        // Check if the user's cart exists
        guard var userCart = self.userCarts[currentUser.uid] else {
            print("User's cart is empty or not loaded")
            return
        }

        if let index = userCart.firstIndex(where: { $0.id == product.id }) {
            userCart.remove(at: index)
            
            self.userCarts[currentUser.uid] = userCart

            let db = Firestore.firestore()
            let userCartRef = db.collection("users").document(currentUser.uid).collection("cart")
            let cartItemRef = userCartRef.document(product.id)

            cartItemRef.delete { error in
                if let error = error {
                    print("Error removing product from cart: \(error)")
                } else {
                    print("Product removed from cart successfully")
                    self.fetchUserCarts()
                }
            }
        } else {
            print("Product not found in user's cart")
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
                let documentID = document.documentID
                if let product = document.data() as? [String: Any] {
                    let convertedProduct = self.convertFirestoreDataToProduct(documentID, product)
                    userCart.append(convertedProduct)
                }
            }
            self.userCarts[currentUser.uid] = userCart
        }
    }

    func convertFirestoreDataToProduct(_ documentID: String, _ data: [String: Any]) -> Product {
        guard
            let name = data["name"] as? String,
              let description = data["description"] as? String,
              let price = data["price"] as? Int,
              let imageURLString = data["image"] as? String,
              let imageURL = URL(string: imageURLString),
              let painter = data["painter"] as? String,
              let quantity = data["quantity"] as? Int
        else {
            fatalError("Failed to extract product data from Firestore document")
        }

        return Product(id: documentID, name: name, image: imageURL, description: description, painter: painter, price: price, quantity: quantity)
    }
}