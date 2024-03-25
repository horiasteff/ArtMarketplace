//
//  VirtualWalletView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 21.03.2024.
//

import SwiftUI
import Firebase
import Combine

struct VirtualWalletView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var userWalletManager: UserWalletManager
    @State private var isShowingAddMoneyForm = false
    @State private var isShowingWithdrawMoneyForm = false

    var body: some View {
        VStack {
            VStack {
                Spacer()
                VStack{
//                    HStack{
//                        Image("wallet")
//                    }
                Text("Wallet Balance")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("kPrimary"))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                Text("\(String(format: "%.2f", userWalletManager.walletBalance)) RON")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("kPrimary"))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                    HStack{
                        NavigationLink(destination: AddMoneyFormView(isPresented: $isShowingAddMoneyForm)) {
                                        Image(systemName: "plus.circle.fill")
                                            .imageScale(.medium)
                                            .font(.title)
                                        Text("Add Money")
                                    }
                                    .padding()
                                    
                        Spacer()
                        
                        NavigationLink(destination: WithdrawMoneyFormView(isPresented: $isShowingWithdrawMoneyForm, userWalletManager: userWalletManager)) {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .imageScale(.medium)
                                            .font(.title)
                                        Text("Withdraw Money")
                                    }
                                    .padding()
                        
                    }
                    .offset(y: +45)
            }
            .onAppear {
                userWalletManager.fetchWalletBalance(for: viewModel.currentUser?.id ?? "")
              //  userWalletManager.fetchWalletBalance(for: String(User.MOCK_USER.wallet))
            }
                ForEach(0..<5) { _ in
                       Spacer()
                   }
            }
            .background(Color("kPrimary"))

            VStack {
                // Second VStack for the bottom section
                Spacer()
                Text("Implementation in progress...")
                    .font(.title)
                    .foregroundColor(Color("kPrimary"))
                    .padding()
                    .background(Color("kSecondary"))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .background(Color("kSecondary"))
            .cornerRadius(20)
            .offset(y: -100)
        }
        .background(Color("kSecondary"))
        }
    }

#Preview {
    
    VirtualWalletView(userWalletManager: UserWalletManager())
        .environmentObject(AuthViewModel())
}
   

class UserWalletManager: ObservableObject {
    private let db = Firestore.firestore()
    @Published var walletBalance: Double = 0.0

    
    func fetchWalletBalance(for userId: String) {
        let userDocRef = db.collection("users").document(userId)
        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                if let walletBalance = document.data()?["wallet"] as? Double {
                    self.walletBalance = walletBalance
                } else {
                    print("Wallet balance not found or invalid")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func addMoney(amount: Double) {
        // Add the given amount to the wallet balance
        walletBalance += amount
        
        // Update the wallet balance in Firestore (assuming you have a function to update Firestore)
        updateWalletBalanceInFirestore(withAmount: amount)
    }
    
    func withdrawMoney(amount: Double) {
        // Add the given amount to the wallet balance
        walletBalance -= amount
        
        // Update the wallet balance in Firestore (assuming you have a function to update Firestore)
        withdrawWalletBalanceInFirestore(withAmount: amount)
    }
    
    func updateWalletBalanceInFirestore(withAmount: Double) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(currentUser.uid)

        userDocRef.setData(["wallet": FieldValue.increment(withAmount)], merge: true) { error in
            if let error = error {
                print("Error updating wallet balance in Firestore: \(error.localizedDescription)")
            } else {
                print("Wallet balance updated successfully in Firestore")
            }
        }
    }
    
    func withdrawWalletBalanceInFirestore(withAmount: Double) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(currentUser.uid)
        
        userDocRef.setData(["wallet": FieldValue.increment(-withAmount)], merge: true) { error in
            if let error = error {
                print("Error updating wallet balance in Firestore: \(error.localizedDescription)")
            } else {
                print("Wallet balance updated successfully in Firestore")
            }
        }
    }
}


