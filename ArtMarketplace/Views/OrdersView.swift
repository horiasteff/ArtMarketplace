//
//  OrdersView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 29.03.2024.
//

import SwiftUI
import Firebase

struct OrdersView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var userWalletManager = UserWalletManager.shared
    @State private var orders: [Order] = []
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            if orders.isEmpty {
                Text("No orders found")
            } else {
                List(orders, id: \.id) { order in
                    VStack(alignment: .leading) {
                        Text("Order ID: \(order.id)")
                            .font(.headline)
                        Text("Total Price: \(order.totalPrice)")
                        Text("Type: \(order.type)")
                        Text("Date: \(order.date)")
                        ForEach(order.products, id: \.id) { product in
                            VStack(alignment: .leading) {
                                Text("Product ID: \(product.id)")
                                Text("Name: \(product.name)")
                                Text("Price: \(product.price)")
                                Text("Quantity: \(product.quantity)")
                                Text("Description: \(product.description)")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Orders")
        .onAppear {
            fetchOrders()
        }
    }
    
    func fetchOrders() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }
        
        let ordersCollectionRef = db.collection("users").document(currentUser.uid).collection("orders")
        
        ordersCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching orders: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No orders found")
                return
            }
            
            self.orders = documents.compactMap { document in
                    // Decode the products array from Firestore
                    let data = document.data()
                    let productsData = data["products"] as? [[String: Any]] ?? []
                    let products = productsData.compactMap { productData -> Product? in
                        do {
                            return try Firestore.Decoder().decode(Product.self, from: productData)
                        } catch {
                            print("Error decoding product: \(error.localizedDescription)")
                            return nil
                        }
                    }
                    
                    // Decode other properties of the order
                    let id = document.documentID
                    let type = data["type"] as? String ?? ""
                    let dateTimestamp = data["date"] as? Timestamp ?? Timestamp()
                    let date = dateTimestamp.dateValue()
                    let totalPrice = data["totalPrice"] as? Double ?? 0.0
                    
                    return Order(id: id, type: type, date: date, products: products, totalPrice: totalPrice)
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
            .environmentObject(AuthViewModel())
    }
}
