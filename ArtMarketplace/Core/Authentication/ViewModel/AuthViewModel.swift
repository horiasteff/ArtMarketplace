//
//  AuthViewModel.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 07.01.2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool {get}
}

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func singIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            showToast = true
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, wallet: Double) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, wallet: wallet)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        }catch {
            print("Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("I just signed out")
        } catch {
            print ("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            return
        }
        
        deleteUserDataFromFirestore(userId: userId)
        signOut()
    }

    private func deleteUserDataFromFirestore(userId: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.delete { error in
            if let error = error {
                print("Error deleting user data from Firestore: \(error.localizedDescription)")
            } else {
                print("User data deleted from Firestore.")
                self.deleteAccountFromAuthentication(userId: userId)
            }
        }
    }

    private func deleteAccountFromAuthentication(userId: String) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                print("User deleted successfully from Authentication.")
            }
        }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {
                    self.currentUser = nil 
                    return
                }
                
                do {
                    let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
                    if let user = try? snapshot.data(as: User.self) {
                        self.currentUser = user
                        print("Debug the current user is \(String(describing: self.currentUser))")
                    }
                } catch {
                    print("Failed to fetch user with error \(error.localizedDescription)")
                }
       }
    
     func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error resetting password: \(error.localizedDescription)")
            } else {
                print("Password reset email sent. Please check your email.")
            }
           // self.showAlert = true
        }
    }
}
