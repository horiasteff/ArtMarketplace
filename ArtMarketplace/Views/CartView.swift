//
//  CartView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject private var productManager = ProductManager()
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {        
        ScrollView {
            if let currentUser = viewModel.currentUser {
                if let userCart = productManager.userCarts[currentUser.id] {
                    if userCart.count > 0 {
                        ForEach(userCart) { product in
                            CartProductView(product: product)
                        }
                        HStack {
                            Text("Your total is ")
                            Spacer()
                            Text("RON \(productManager.total)")
                                .bold()
                        }
                        .padding()
                        PaymentButton(action: {})
                            .padding()
                    } else {
                        Text("The cart is empty")
                    }
                } else {
                    Text("The cart is empty")
                }
            } else {
                Text("Please log in to view your cart")
            }
        }
        .navigationTitle(Text("My Cart"))
        .padding(.top)
    }
}

#Preview {
    CartView()
        .environmentObject(ProductManager())
}
