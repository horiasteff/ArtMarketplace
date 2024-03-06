//
//  CartView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    var body: some View {
        ScrollView{
            if cartManager.products.count > 0 {
                ForEach(cartManager.products, id: \.id){product in
                        CartProductView(product: product)
                }
                HStack{
                    Text("You total is ")
                    Spacer()
                    Text("RON \(cartManager.total)")
                        .bold()
                    
                    
                }
                .padding()
                
                PaymentButton(action: {})
                    .padding()
            } else {
                Text("The cart is empty")
            }
        }
        .navigationTitle(Text("My Cart"))
        .padding(.top)
    }
}

#Preview {
    CartView()
        .environmentObject(CartManager())
}
