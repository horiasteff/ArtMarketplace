//
//  OrderListView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 31.03.2024.
//

import SwiftUI

struct OrderListView: View {
    var order: Order
    var formattedDate: DateFormatter
       
       var body: some View {
           VStack(alignment: .leading, spacing: 8) {
               
               let formattedDate = DateFormatter.localizedString(from: order.date, dateStyle: .short, timeStyle: .none)
               Text("Total Price: \(String(format: "%.2f", order.totalPrice)) RON")
               Text("Type: \(order.type)")
               Text("Date: \(formattedDate)")
                   .bold()
                   .foregroundColor(.black)
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
    OrderListView(order: Order.MOCK_ORDER, formattedDate: DateFormatter())
}
