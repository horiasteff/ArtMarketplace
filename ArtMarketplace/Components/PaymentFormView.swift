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
    
    init(viewModel: AuthViewModel, productManager: ProductManager) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.productManager = productManager
         let currentUser = viewModel.currentUser
        _name = State(initialValue: currentUser?.fullname ?? "")
        _email = State(initialValue: currentUser?.email ?? "")
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
                        Text("Total de plata:")
                        Spacer()
                        Text("RON \(productManager.total)")
                    }
                    Button(action: {
                        productManager.processPayment(paymentType: "Order", totalAmount: productManager.total)
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
