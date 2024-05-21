//
//  TicketManager.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 29.04.2024.
//

import Foundation
import FirebaseFirestore
import Firebase

class TicketManager: ObservableObject {
    @Published var tickets: [Ticket] = []
    private let db = Firestore.firestore()
    
    func fetchTickets(forUserID userID: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }
        let userTicketsRef = db.collection("users").document(currentUser.uid).collection("tickets")
        
        userTicketsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching tickets: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No tickets found")
                return
            }
            
            self.tickets = documents.compactMap { document in
                let data = document.data()
                
                let entityName = data["entityName"] as? String ?? ""
                let id = document.documentID
                let price = data["price"] as? Double ?? 0.0
                
                return Ticket(id: id, entityName: entityName, price: price)
            }
        }
        
        func buyTicket(userID: String, entityName: String, price: Double) {
            let db = Firestore.firestore()
            let userTicketsRef = db.collection("users").document(userID).collection("tickets")
            let newTicketRef = userTicketsRef.document()
            
            let data: [String: Any] = [
                "id": "",
                "entityName": entityName,
                "price": price
            ]
            
            newTicketRef.setData(data) { error in
                if let error = error {
                    print("Error adding ticket: \(error)")
                } else {
                    print("Ticket added successfully")
                }
            }
        }
    }
}
