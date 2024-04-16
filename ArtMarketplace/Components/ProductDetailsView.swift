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
        ScrollView(showsIndicators: false){
            ZStack{
                Color("kSecondary")
                
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
                                Spacer()
                                
                                Button{
                                    productManager.addToCart(product: product, documentID: product.id)
                                } label:{
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color("kPrimary"))
                                        .frame(width: 25, height: 25)
                                        //.padding(.trailing)
                                    Text("Add to cart")
                                }
                            }
                            
                            Text("Description")
                                .font(.title2)
                                .fontWeight(.medium)
                            Spacer()
                            
                            Text(product.description)
                            Spacer()
                            Spacer()
                            
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("kSecondary").opacity(1), Color("kSecondary").opacity(0)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
                        .cornerRadius(20)
                        .offset(y: -30)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("kSecondary"))
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
