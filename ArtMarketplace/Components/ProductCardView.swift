//
//  ProductCardView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI

struct ProductCardView: View {
    @EnvironmentObject var cartManager: CartManager
    var product: Product
    var body: some View {
        ZStack{
            Color("kSecondary")
            
            ZStack(alignment: .bottomTrailing){
                VStack(alignment: .leading){
                    Image(product.image)
                        .resizable()
                        .frame(width: 155, height: 120)
                        .cornerRadius(12)
                    
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.vertical, 1)
                    Text(product.painter)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.vertical, 0.5)
                    Text("RON \(product.price)")
                        .foregroundColor(.black)
                        .bold()
                    
                }
                Button{
                    cartManager.addToCart(product: product)
                } label:{
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(Color("kPrimary"))
                        .frame(width: 25, height: 25)
                        .padding(.trailing)
                }
            }
        }
        .frame(width: 185, height: 220)
        .cornerRadius(15)
    }
}

#Preview {
    ProductCardView(product: productList[0])
        .environmentObject(CartManager())
}
