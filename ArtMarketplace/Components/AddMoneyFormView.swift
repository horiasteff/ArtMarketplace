//
//  AddMoneyFormView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 21.03.2024.
//

import SwiftUI

struct AddMoneyFormView: View {
    @Binding var isPresented: Bool
    @State private var amount: String = ""
    @StateObject private var userWalletManager = UserWalletManager()
    
    var body: some View {
        VStack {
            TextField("Enter amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Money") {
                // Validate amount and add money
                guard let amount = Double(amount) else {
                    // Handle invalid amount
                    return
                }
                userWalletManager.updateWalletBalanceInFirestore(withAmount: amount)
                isPresented = false // Close the form
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    AddMoneyFormView(isPresented: .constant(false))
}
