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
                VStack(alignment: .leading) {
                    Text("Orders")
                        .font(.largeTitle .bold())
                        .foregroundColor(Color("kPrimary"))
                }
                Text("No orders found")
            } else {
                NavigationStack{
                    VStack(alignment: .leading) {
                        Text("Orders")
                            .font(.largeTitle .bold())
                            .foregroundColor(Color("kPrimary"))
                    }
                    Spacer()
                    List(orders, id: \.id) { order in
                        NavigationLink(destination: OrderDetailsView(order: order)) {
                            OrderListView(order: order, formattedDate: DateFormatter())
                        }
                    }
                }
            }
        }
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
                
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let dateTimestamp = data["date"] as? Timestamp ?? Timestamp()
                let date = dateTimestamp.dateValue()
                let totalPrice = data["totalPrice"] as? Double ?? 0.0
                let address = data["address"] as? String ?? ""
                let phone = data["phone"] as? String ?? ""
                
                return Order(id: id, name: name, type: type, date: date, address: address, phone: phone, products: products, totalPrice: totalPrice)
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
