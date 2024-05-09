//
//  TicketManager.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 29.04.2024.
//

import Foundation
import FirebaseFirestore

class TicketManager: ObservableObject {
    @Published var tickets: [Ticket] = []
    private let db = Firestore.firestore()
    
    func fetchTickets(forUserID userID: String) {
       // let db = Firestore.firestore()
        let userTicketsRef = db.collection("users").document(userID).collection("tickets")
        
//        userTicketsRef.addSnapshotListener { [weak self] snapshot, error in
//            guard let snapshot = snapshot else {
//                print("Error fetching tickets: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            self?.tickets = snapshot.documents.compactMap { document in
//                do {
//                    return try document.data(as: Ticket.self)
//                } catch {
//                    print("Error decoding ticket: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//        }
        
        userTicketsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No transactions found")
                return
            }
            
            self.tickets = documents.compactMap { document in
                do {
                    let ticket = try document.data(as: Ticket.self)
                    return ticket
                } catch {
                    print("Error decoding transaction: \(error.localizedDescription)")
                    return nil
                }
            }
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
