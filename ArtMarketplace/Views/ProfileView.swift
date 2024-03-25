//
//  ProfileView.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 13.11.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var cartManager: CartManager
    var body: some View {
        NavigationStack{
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
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            
                            Spacer()
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Section("Account"){
                        NavigationLink(destination: VirtualWalletView(userWalletManager: UserWalletManager())) {
                            SettingsRowView(imageName: "wallet.pass", title: "Virtual Wallet", tintColor: .blue)
                        }
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out", tintColor: .red)
                        }
                        Button {
                            print("Delete account")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete account", tintColor: .red)
                        }
                    }
                }
                .navigationBarTitle("Profile", displayMode: .inline)
            }
        }
        .environmentObject(CartManager())
    }
}

#Preview {
    ProfileView()
        .environmentObject(CartManager())
    
}
