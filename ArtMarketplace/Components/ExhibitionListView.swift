//
//  ExhibitionListView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 16.04.2024.
//

import SwiftUI

struct ExhibitionListView: View {
    @ObservedObject private var productManager = ProductManager()
    @StateObject private var userWalletManager = UserWalletManager.shared
    @StateObject var viewModel: AuthViewModel

    var body: some View { 
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Exhibition List")
                    .font(.largeTitle .bold())
                    .foregroundColor(Color("kPrimary"))
            }
            Spacer()
            List(productManager.entities) { entity in
                NavigationLink{
                    ExhibitionView(isPaid: .constant(false), entityName: entity.entityName)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(TicketManager())
                } label: {
                    VStack(alignment: .leading) {
                        HStack{
                            Spacer()
                            Text("\(entity.entityName)").bold()
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text("\(entity.startDate.formattedDate())")
                            Text(" - ")
                            Text("\(entity.endDate.formattedDate())")
                            Spacer()
                        }
                        
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(0.9), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(10)
                    .padding(.vertical, 4)
                }
                .disabled(entity.startDate.isDateInFuture(withFormat: "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z") || entity.endDate.isDateInPast(withFormat: "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z"))
            }
            .onAppear {
                productManager.fetchEntities()
            }
        }
        .environmentObject(userWalletManager)
    }
}

extension String {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
    func isDateInFuture(withFormat format: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let startDate = dateFormatter.date(from: self) else {
            return false
        }
        return startDate > Date()
    }
    
    func isDateInPast(withFormat format: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let endDate = dateFormatter.date(from: self) else {
            return false
        }
        return endDate < Date()
    }
}

#Preview {
    ExhibitionListView(viewModel: AuthViewModel())
}
