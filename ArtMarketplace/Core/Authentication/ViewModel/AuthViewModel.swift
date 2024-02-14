//
//  AuthViewModel.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 07.01.2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        
    }
    
    func singIn(withEmail email: String, password: String) async throws {
        print("Sign in...")
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        }catch {
            print("Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        //self.currentUser = snapshot.data(as: User.self)
    }
    
}
