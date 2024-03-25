//
//  CartProductView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI
import URLImage

struct CartProductView: View {
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
           
            VStack{
                Button{
                    productManager.deleteProductFromCart(product: product)
                } label:{
                    Image(systemName: "trash")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 25, height: 25)
                       
                }
                
                HStack{
                    Button{
                        productManager.removeFromCart(product: product)
                    } label:{
                        Image(systemName: "minus.circle")
                    }
                    Text("\(product.quantity)")
                    Button{
                        productManager.addToCart(product: product, documentID: product.id)
                    } label:{
                        Image(systemName: "plus.circle")
                    }
                }
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
    CartProductView(product: productList[1])
        .environmentObject(ProductManager())
}
