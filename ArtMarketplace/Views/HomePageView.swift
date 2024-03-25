//
//  HomePageView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI

struct HomePageView: View {
    @ObservedObject private var productManager = ProductManager()
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
                Color.white
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack(alignment: .leading) {
                        Text("    Find the most \nLuxurious")
                            .font(.largeTitle .bold())
                        
                        + Text(" Pictures")
                            .font(.largeTitle .bold())
                            .foregroundColor(Color("kPrimary"))
                    }
                    
                    SearchView()
                    
                    ImageSliderView()
                    
                    HStack{
                        Text("New Rivals")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        NavigationLink(destination: {
                            ProductsView()
                        }, label: {
                            Image(systemName: "circle.grid.2x2.fill")
                                .foregroundColor(Color("kPrimary"))
                        })
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(productManager.productList, id: \.id){ product in
                                NavigationLink{
                                    ProductDetailsView(product: product)
                                } label: {
                                    ProductCardView(product: product)
                                       //.environmentObject(cartManager)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView()
}
