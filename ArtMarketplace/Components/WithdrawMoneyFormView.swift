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
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                TextField("   Enter amount", text: $amount)
                    .frame(height: 50)
                    .background(Color("kSecondary"))
                    .cornerRadius(20)
                    .padding()
                
                Button("Withdraw Money") {
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
                .frame(width: 150, height: 50)
                .background(Color("kPrimary"))
                .cornerRadius(20)
                .foregroundColor(.white)
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
}

#Preview {
    WithdrawMoneyFormView(isPresented: .constant(false), userWalletManager: UserWalletManager())
}

