//
//  ContentView.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 10.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                ProfileView()
            }else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
