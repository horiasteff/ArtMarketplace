//
//  ExhibitionListView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 16.04.2024.
//

import SwiftUI

struct ExhibitionListView: View {
    @ObservedObject private var productManager = ProductManager()

    var body: some View {
        
        NavigationView {
            List(productManager.entities) { entity in
                NavigationLink{
                    ExhibitionView(userWalletManager: UserWalletManager(), entityName: entity.entityName)
                        .navigationBarBackButtonHidden(true)
                }label: {
                    VStack(alignment: .leading) {
                        HStack{
                            Spacer()
                            Text("\(entity.entityName)").bold()
                            Spacer()
                        }

                        Text("\(entity.startDate.formattedDate())")
                        Text("\(entity.endDate.formattedDate())")
                    }
                }
                .disabled(entity.startDate.isDateInFuture(withFormat: "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z") || entity.endDate.isDateInPast(withFormat: "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z"))
                
            }
            .onAppear {
                productManager.fetchEntities()
            }
        }
        
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
    ExhibitionListView()
}
