//
//  ExhibitionView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI
import URLImage
import FirebaseFirestore


struct ExhibitionView: View {
    @ObservedObject private var productManager = ProductManager()
    @EnvironmentObject var ticketManager: TicketManager
    @EnvironmentObject var userWalletManager: UserWalletManager
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment (\.dismiss) var dismiss
    @State private var showToast = false
    //@StateObject private var isPaidManager = IsPaidManager()
   // @State private var tickets: [Ticket] = []
    @Binding var isPaid: Bool // Use a binding for isPaid
    @State private var isTicketBought = false
    var exhibitionPrice = 20
    var entityName: String
    
    
    var hasValidTicket: Bool {
        guard let userID = viewModel.currentUser?.id else {
            return false
        }
        
        let db = Firestore.firestore()
        let userTicketsRef = db.collection("users").document(userID).collection("tickets")
        
        var isValid = false
        
        userTicketsRef.whereField("entityName", isEqualTo: entityName).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching tickets: \(error)")
                return
            }
            
            if let documents = snapshot?.documents, !documents.isEmpty {
                isValid = true
            }
        }
        
        return isValid
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                if isTicketBought {
                    showExhibitionContent()
                } else {
                    Button(action: {
                        buyTicket()
                    }) {
                        Text("Buy Ticket")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .overlay(
            VStack {
                if showToast {
                    Text("You do not have enough money")
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
        .onAppear{
            userWalletManager.fetchWalletBalance(for: viewModel.currentUser?.id ?? "")
            ticketManager.fetchTickets(forUserID: viewModel.currentUser?.id ?? "")
                            
        }
    }
    
    func hasValidTicket(completion: @escaping (Bool) -> Void) {
        guard let userID = viewModel.currentUser?.id else {
            // Handle the case where userID is nil
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let userTicketsRef = db.collection("users").document(userID).collection("tickets")

        userTicketsRef.whereField("entityName", isEqualTo: entityName).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching tickets: \(error)")
                completion(false)
                return
            }

            if let documents = snapshot?.documents, !documents.isEmpty {
                // User has a ticket for this exhibition
                completion(true)
            } else {
                // User does not have a ticket for this exhibition
                completion(false)
            }
        }
    }
    
    func buyTicket() {
        guard let userID = viewModel.currentUser?.id else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userTicketsRef = db.collection("users").document(userID).collection("tickets")
        
        var ticketData: [String: Any] = [
            "id": "",
            "entityName": entityName,
            "price": 20
            // Add other ticket information as needed
        ]
        
        let documentRef = userTicketsRef.addDocument(data: ticketData) { error in
            if let error = error {
                print("Error adding ticket: \(error.localizedDescription)")
                showToast = true
                return
            } else {
                print("Ticket added successfully")
                isTicketBought = true
            }
        }
        
        let ticketID = documentRef.documentID
        ticketData["id"] = ticketID
        
        documentRef.setData(ticketData, merge: true)
    }
    

    
    
    func showExhibitionContent() -> some View {
        VStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                HStack{
                    Image(systemName: "arrowshape.backward.fill")
                        .resizable()
                        .foregroundColor(Color("kSecondary"))
                        .frame(width: 30, height: 30)
                        .padding(15)
                    Spacer()
                }
            }
            Spacer()
            Spacer()
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(productManager.productList.filter { $0.entity == entityName }) { product in
                        NavigationLink(destination: ProductDetailsView(product: product)) {
                            VStack {
                                URLImage(product.image) { image in
                                    image
                                        .resizable()
                                        .cornerRadius(15)
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(radius: 10, y: 10)
                                        .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive, axis: .horizontal) { effect, phase in
                                            effect
                                                .scaleEffect(1 - abs(phase.value))
                                                .opacity(1 - abs(phase.value))
                                                .rotation3DEffect(.degrees(phase.value * 90), axis: (x: 0, y: -1, z: 0))
                                        }
                                }
                                .frame(width: 300, height: 300)
                                Text(product.name)
                                    .font(.headline)
                                    .padding(.horizontal, 40)
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: 200)
            .safeAreaPadding(.horizontal, 52)
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned)
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
    }
        

//class IsPaidManager: ObservableObject {
//    @Published var isPaid: Bool = false
//}

#Preview {
    ExhibitionView(isPaid: .constant(false), entityName: Entity.MOCK_ENTITY.entityName)
        .environmentObject(AuthViewModel())
        .environmentObject(UserWalletManager())
        .environmentObject(TicketManager())
}
