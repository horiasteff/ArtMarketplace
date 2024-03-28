//
//  PaymentFormView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 26.03.2024.
//

import SwiftUI

struct PaymentFormView: View {
    @StateObject var viewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var address = ""
    @State private var paymentType = "Cash" 
    let productManager: ProductManager
    @ObservedObject private var userWalletManager = UserWalletManager.shared
    
    init(viewModel: AuthViewModel, productManager: ProductManager) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.productManager = productManager
         let currentUser = viewModel.currentUser
        _name = State(initialValue: currentUser?.fullname ?? "")
        _email = State(initialValue: currentUser?.email ?? "")
        
        userWalletManager.fetchWalletBalance(for: viewModel.currentUser?.id ?? "")

    }
    
    var body: some View {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    TextField("Address", text: $address)
                }
                
                Section(header: Text("Payment Details")) {
                    Picker(selection: $paymentType, label: Text("Payment Type")) {
                        Text("Cash").tag("Cash")
                        Text("Card").tag("Card")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    HStack{
                        Text("Total amount:")
                        Spacer()
                        Text("RON \(String(format: "%.2f", productManager.total))")
                        
                    }
                    Button(action: {
                        userWalletManager.processPayment(paymentType: paymentType, totalAmount: productManager.total, userWalletBalance: userWalletManager.walletBalance)
                    }) {
                        Text("Proceed to Payment")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .background(Color.clear)
            .navigationBarTitle("Payment Details")
    }
}

#Preview {
    PaymentFormView(viewModel: AuthViewModel() , productManager: ProductManager())
        .environmentObject(AuthViewModel())
}
