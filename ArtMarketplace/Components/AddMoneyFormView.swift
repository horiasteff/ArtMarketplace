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
    @State private var showToast = false
    @StateObject private var userWalletManager = UserWalletManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Enter amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Money") {
                guard let amount = Double(amount), amount > 0 else {
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                    return
                }
                userWalletManager.updateWalletBalanceInFirestore(withAmount: amount)
                userWalletManager.recordTransaction(type: "Money Added", amount: amount)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
        .overlay(
                    VStack {
                        if showToast {
                            Text("Please enter a valid amount")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    , alignment: .top
                )
    }
}

#Preview {
    AddMoneyFormView(isPresented: .constant(false))
}
