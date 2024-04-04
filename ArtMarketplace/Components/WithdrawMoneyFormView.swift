//
//  WithdrawMoneyFormView.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 24.03.2024.
//

import SwiftUI

struct WithdrawMoneyFormView: View {
    @Binding var isPresented: Bool
    @State private var amount: String = ""
    @State private var showToast = false
    @State private var showToast2 = false
    @ObservedObject var userWalletManager: UserWalletManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Enter amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Withdraw Money") {
                // Validate amount and withdraw money
                guard let withdrawAmount = Double(amount), withdrawAmount > 0 else {
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                    return
                }

                guard withdrawAmount <= userWalletManager.walletBalance else {
                        showToast2 = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast2 = false
                            }
                        }
                        return
                    }

                userWalletManager.withdrawWalletBalanceInFirestore(withAmount: withdrawAmount)
                userWalletManager.recordTransaction(type: "Money Withdrawed", amount: withdrawAmount)
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
                        if showToast2 {
                            Text("There is no enough money to withdraw")
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
    WithdrawMoneyFormView(isPresented: .constant(false), userWalletManager: UserWalletManager())
}

