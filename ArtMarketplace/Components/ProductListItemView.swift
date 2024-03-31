//
//  ProductListItemView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 31.03.2024.
//

import SwiftUI
import URLImage

struct ProductListItemView: View {
    var product: Product
    
    var body: some View {
        HStack {
//            Image(systemName: "photo") // Placeholder image
//                .resizable()
//                .frame(width: 50, height: 50)
            
            URLImage(product.image) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(12)
                }
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("Price: \(product.price)")
                Text("Quantity: \(product.quantity)")
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProductListItemView(product: productList[1])
}
