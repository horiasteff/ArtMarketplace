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
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                TextField("   Enter amount", text: $amount)
                    .frame(height: 50)
                    .background(Color("kSecondary"))
                    .cornerRadius(20)
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
                    Spacer()
                }
                , alignment: .top
            )
        }
    }
}


struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

#Preview {
    AddMoneyFormView(isPresented: .constant(false))
}
