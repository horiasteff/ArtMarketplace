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
                Spacer()
                HStack{
                    Spacer()
                    Text("Transactions")
                        .bold()
                        .font(.title)
                    Spacer()
                }
                Spacer()
                
                ScrollView(.vertical) {
                    ForEach(userWalletManager.transactions, id: \.id) { transaction in
                            TransactionView(transaction: transaction, formattedDate: DateFormatter())
                                .padding(.horizontal)
                        }
                }
                .onAppear {
                    userWalletManager.fetchTransactions()
                }
            
                Spacer()
            }
            .background(Color("kSecondary"))
            .cornerRadius(20)
            .offset(y: -70)
        }
        .background(Color("kSecondary"))
        }

    }

#Preview {
    VirtualWalletView(userWalletManager: UserWalletManager())
        .environmentObject(AuthViewModel())
}
   

class UserWalletManager: ObservableObject {
    @EnvironmentObject var viewModel: AuthViewModel
    static let shared = UserWalletManager()
    private let db = Firestore.firestore()
    @Published var walletBalance: Double = 0.0
    @Published var transactions: [Transaction] = []

    
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
        walletBalance += amount
        
        recordTransaction(type: "Money added", amount: amount)
        
        updateWalletBalanceInFirestore(withAmount: amount)
    }
    
    func withdrawMoney(amount: Double) {
        walletBalance -= amount
        
        recordTransaction(type: "Money withdrawed", amount: amount)
        
        withdrawWalletBalanceInFirestore(withAmount: amount)
    }
    
     func recordTransaction(type: String, amount: Double) {
        
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }
         let transactionCollectionRef = db.collection("users").document(currentUser.uid).collection("transactions")
        
         var transactionData: [String: Any] = [
            "id": "",
            "type": type,
            "amount": amount,
            "date": Date()
        ]
        
         let documentRef = transactionCollectionRef.addDocument(data: transactionData) { error in
            if let error = error {
                print("Error adding transaction: \(error.localizedDescription)")
            } else {
                print("Transaction added successfully")
            }
        }
         let transactionID = documentRef.documentID
         transactionData["id"] = transactionID
         
         // Update the document in Firestore with the generated ID
         documentRef.setData(transactionData, merge: true)
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
    
    func fetchTransactions() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }
        
        let transactionCollectionRef = db.collection("users").document(currentUser.uid).collection("transactions")
        
        transactionCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No transactions found")
                return
            }
            
            self.transactions = documents.compactMap { document in
                do {
                    var transaction = try document.data(as: Transaction.self)
                    return transaction
                } catch {
                    print("Error decoding transaction: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    func processPayment(paymentType: String, totalAmount: Double, userWalletBalance: Double) {
        if paymentType == "Card" {
            if userWalletBalance >= totalAmount {
                recordTransaction(type: "Order", amount: totalAmount)
                withdrawWalletBalanceInFirestore(withAmount: totalAmount)
                print("Payment successful!")
            } else {
                print("Atata am: \(userWalletBalance)")
                print("Insufficient balance.")
            }
        } else {
            print("Payment type: \(paymentType)")
        }
    }
}


