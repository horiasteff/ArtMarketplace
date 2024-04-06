//
//  OrderDetailsView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 05.04.2024.
//

import SwiftUI
import URLImage

struct OrderDetailsView: View {
    var order: Order
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Order Details")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 16)
                
                Text("Total Price: \(String(format: "%.2f", order.totalPrice)) RON")
                Text("Type: \(order.type)")
                Text("Address: \(order.address)")
                Text("Name: \(order.name)")
                
                Text("Products:")
                    .font(.headline)
                    .padding(.top, 16)
                
                ForEach(order.products, id: \.id) { product in
                    HStack{
                        URLImage(product.image) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(12)
                        }
                        .padding()
                        VStack(alignment: .leading) {
                            Text("Name: \(product.name)")
                            Text("Price: \(product.price) RON")
                            Text("Quantity: \(product.quantity)")
                        }
                        Spacer()
                    }
                    
                    .frame(width: 300, height: 90)
                    
                }
                .listStyle(PlainListStyle())
                .background(LinearGradient(gradient: Gradient(colors: [Color("kSecondary").opacity(1), Color("kSecondary").opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(20)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    OrderDetailsView(order: Order.MOCK_ORDER)
}
