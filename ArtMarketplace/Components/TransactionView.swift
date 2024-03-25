//
//  TransactionView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 25.03.2024.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    var formattedDate: DateFormatter
    var body: some View {
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 5){
                Text(transaction.type)
                    .bold()
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(String(format: "%.2f", transaction.amount)) RON")
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
            
            let formattedDate = DateFormatter.localizedString(from: transaction.date, dateStyle: .short, timeStyle: .none)
            
            Text("\(formattedDate)")
                .bold()
                .foregroundColor(.white)

        }
        .padding(.horizontal)
        .background(Color("kPrimary"))
        .cornerRadius(12)
        .frame(width: .infinity,  alignment: .leading)
        .padding()
    }
}

#Preview {
    TransactionView(transaction: Transaction.MOCK_TRANSACTION, formattedDate: DateFormatter())
}
