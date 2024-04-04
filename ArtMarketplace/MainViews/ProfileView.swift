//
//  ProfileView.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 13.11.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Profile")
                    .font(.largeTitle .bold())
                    .foregroundColor(Color("kPrimary"))
            }
            if let user  = viewModel.currentUser {
                List{
                    Section{
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(user.fullname)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Section("General"){
                        HStack {
                            NavigationLink(destination: VirtualWalletView(userWalletManager: UserWalletManager())) {
                                SettingsRowView(imageName: "wallet.pass", title: "Virtual Wallet", tintColor: Color("kPrimary"))
                            }
                        }
                    }
                    Section("Account"){

                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out", tintColor: .red)
                        }
                        Button {
                            viewModel.resetPassword(email: viewModel.currentUser!.email)
                        } label: {
                            SettingsRowView(imageName: "gear", title: "Reset password", tintColor: Color("kPrimary"))
                        }
//                        Button {
//                            viewModel.deleteAccount()
//                        } label: {
//                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete account", tintColor: .red)
//                        }
                        
                        Button {
                            showAlert = true
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete account", tintColor: .red)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteAccount()
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
