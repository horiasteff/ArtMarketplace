//
//  SearchView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI

struct SearchView: View {
    @State private var search: String = ""
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("Search for picture", text: $search)
                    .padding()
            }
            .background(Color("kSecondary"))
            .frame(height: 40)
            .cornerRadius(12)
            
            Image(systemName: "camera")
                .padding()
                .foregroundColor(.white)
                .background(Color("kPrimary"))
                .frame(height: 40)
                .cornerRadius(12)
                
            
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    SearchView()
}
