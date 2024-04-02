//
//  ProductDetailsView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 07.03.2024.
//

import SwiftUI
import URLImage

struct ProductDetailsView: View {
    var product: Product
    @ObservedObject private var productManager = ProductManager()
    var body: some View {
        ScrollView{
            ZStack{
                Color.white
                
                VStack(alignment: .leading){
                    ZStack(alignment: .topTrailing){
                        
                        URLImage(product.image) { image in
                            image
                                .resizable()
                                .frame(width: .infinity, height: 300)
                                .cornerRadius(12)
                        }
                        
                    }
                    VStack(alignment: .leading){
                        HStack{
                            Text(product.name)
                                .font(.title2 .bold())
                            
                            Spacer()
                            
                            Text("RON \(product.price)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .background(Color("kSecondary"))
                                .cornerRadius(12)
                            
                        }
                        .padding(.vertical)
                        
                        HStack {
                            HStack(spacing: 10){
                                ForEach(0..<5){index in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.yellow)
                                }
                                Text("(4.5)")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical)
                            Spacer()
                            Spacer()
                        }
                        
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Text(product.description)
                        Spacer()
                        Button{
                            productManager.addToCart(product: product, documentID: product.id)
                        } label:{
                            
                            HStack{
                                Spacer()
                                Text("Add to cart ")
                                Image(systemName: "plus.circle.fill")
                                Spacer()
                            }
                            .foregroundColor(Color("kPrimary"))
                        }
                        
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .offset(y: -30)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    ProductDetailsView(product: Product.MOCK_PRODUCT)
        .environmentObject(ProductManager())
}

struct ColorDotView: View {
    let color: Color
    var body: some View {
        
        color.frame(width: 25, height: 25)
            .clipShape(Circle())
    }
}
