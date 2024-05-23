//
//  ProductsView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 07.03.2024.
//

import SwiftUI

struct ProductsView: View {
    @ObservedObject private var productManager = ProductManager()
    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    @State private var search: String = ""
    
    var filteredProducts: [Product] {
        if search.isEmpty {
            return productManager.productList.filter {$0.label == "standard"}
        } else {
            return productManager.productList.filter { $0.name.lowercased().contains(search.lowercased()) && $0.label == "standard"}
        }
    }

    var body: some View {

        VStack(alignment: .leading) {
            Text("   Entire collection \nLuxurious")
                .font(.largeTitle .bold())
            
            + Text(" Pictures")
                .font(.largeTitle .bold())
                .foregroundColor(Color("kPrimary"))
        }
        
        SearchBarView(search: $search)
    
        NavigationView{
            ScrollView{
                LazyVGrid(columns: column, spacing: 20){
                    ForEach(filteredProducts, id: \.id){ product in
                        NavigationLink{
                            ProductDetailsView(product: product)
                        } label: {
                            ProductCardView(product: product)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear(){
            self.productManager.fetchData()
        }
    }
}

#Preview {
    ProductsView()
        .environmentObject(ProductManager())
}
