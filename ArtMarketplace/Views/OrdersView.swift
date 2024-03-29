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
    private var db = Firestore.firestore()
    
    var body: some View {
        VStack {
            List(orders, id: \.id) { order in
                VStack(alignment: .leading) {
                    Text("Order ID: \(order.id)")
                        .font(.headline)
                    Text("Total Price: \(order.totalPrice)")
                    Text("Type: \(order.type)")
                    Text("Date: \(order.date)")
                }
            }
            .onAppear {
                fetchOrders()
            }
        }
        .navigationBarTitle("Orders")
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
                do {
                    return try document.data(as: Order.self)
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
}

#Preview {
    OrdersView()
        .environmentObject(AuthViewModel())
}
