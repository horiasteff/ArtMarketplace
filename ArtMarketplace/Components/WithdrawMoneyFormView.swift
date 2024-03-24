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
    @StateObject private var userWalletManager = UserWalletManager()
    @Environment(\.presentationMode) var presentationMode
    
//    init(isPresented: Binding<Bool>, userWalletManager: UserWalletManager) {
//            _isPresented = isPresented
//            self.userWalletManager = userWalletManager
//        }
    
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
                    print(" Balance is thisss: \(userWalletManager.walletBalance)")
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                        return
                    }

                userWalletManager.withdrawWalletBalanceInFirestore(withAmount: withdrawAmount)
                presentationMode.wrappedValue.dismiss() // Close the form
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
    WithdrawMoneyFormView(isPresented: .constant(false))
}

