//
//  SearchBarView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 02.04.2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var search: String
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
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchBarView(search: .constant(""))
}
