//
//  CartProductView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI
import URLImage

struct CartProductView: View {
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject private var productManager = ProductManager()
    var product: Product
    var body: some View {
        HStack(spacing: 20){
            
            URLImage(product.image) { image in
                                   image
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 70)
                                       .cornerRadius(9)
                               }
            
            VStack(alignment: .leading, spacing: 5){
                Text(product.name)
                    .bold()
                Text("RON \(product.price)")
                    .bold()
            }
            .padding()
            
            Spacer()
            
            Image(systemName: "trash")
                .foregroundColor(.red)
                .onTapGesture {
                    // cartManager.removeFromCart(product: product)
                    productManager.removeFromCart(product: product)
                }
            
        }
        .padding(.horizontal)
        .background(Color("kSecondary"))
        .cornerRadius(12)
        .frame(width: .infinity,  alignment: .leading)
        .padding()
    }
}

#Preview {
    CartProductView(product: productList[2])
        .environmentObject(CartManager())
}
