//
//  OrderListView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 31.03.2024.
//

import SwiftUI

struct OrderListView: View {
    var order: Order
       
       var body: some View {
           VStack(alignment: .leading, spacing: 8) {
//               Text("Order ID: \(order.id)")
//                   .font(.headline)
               Text("Total Price: \(order.totalPrice)")
               Text("Type: \(order.type)")
               Text("Date: \(order.date)")
               ForEach(order.products, id: \.id) { product in
                   ProductListItemView(product: product)
               }
           }
           .padding()
           .background(Color.gray.opacity(0.1))
           .cornerRadius(10)
           .padding(.horizontal)
           .padding(.vertical, 4)
       }
}

#Preview {
    OrderListView(order: Order.MOCK_ORDER)
}
