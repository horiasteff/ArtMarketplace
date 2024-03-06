//
//  HomePageView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var cartManager: CartManager
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
                Color.white
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    AppBar()
                    
                    SearchView()
                    
                    ImageSliderView()
                    
                    HStack{
                        Text("New Rivals")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Image(systemName: "circle.grid.2x2.fill")
                            .foregroundColor(Color("kPrimary"))
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(productList, id: \.id){ product in
                                NavigationLink{
                                    Text(product.name)
                                } label: {
                                    ProductCardView(product: product)
                                        .environmentObject(cartManager)
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
        .environmentObject(CartManager())
}

struct AppBar: View {
    @EnvironmentObject var cartManager: CartManager
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "location.north.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                    
                    Text("Bucharest, Romania")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    NavigationLink(destination: Text("")){
                        CartButton(numberOfProducts: cartManager.products.count)
                    }
                }
                Text("Find the most \nLuxurious")
                    .font(.largeTitle .bold())
                
                + Text(" Pictures")
                    .font(.largeTitle .bold())
                    .foregroundColor(Color("kPrimary"))
            }
        }
        .padding()
        .environmentObject(CartManager())
    }
}
