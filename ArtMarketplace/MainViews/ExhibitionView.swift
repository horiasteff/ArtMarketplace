//
//  ExhibitionView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI
import URLImage

struct Ticket {
    let id: String // Unique identifier for the ticket
    let exhibitionName: String
    // Add any other relevant properties
}

struct ExhibitionView: View {
    @ObservedObject private var productManager = ProductManager()
    @EnvironmentObject var userWalletManager: UserWalletManager
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment (\.dismiss) var dismiss
    @State private var showToast = false
   // @State private var isPaid = false
    @StateObject private var isPaidManager = IsPaidManager()
    @State private var tickets: [Ticket] = []
    @Binding var isPaid: Bool // Use a binding for isPaid
    var exhibitionPrice = 20
    var entityName: String
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()

                if hasValidTicket() {
                    // Show content for users with a valid ticket
                    
                    VStack{
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            HStack{
                                Image(systemName: "arrowshape.backward.fill")
                                    .resizable()
                                    .foregroundColor(Color("kSecondary"))
                                    .frame(width: 30, height: 30)
                                    .padding(15)
                                Spacer()
                            }
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(productManager.productList.filter {$0.entity == entityName}) { product in
                                    NavigationLink(destination: ProductDetailsView(product: product)) {
                                        VStack{
                                            URLImage(product.image) { image in
                                                image
                                                    .resizable()
                                                    .cornerRadius(15)
                                                    .aspectRatio(contentMode: .fit)
                                                    .shadow(radius: 10, y: 10)
                                                    .scrollTransition(topLeading: .interactive,
                                                                      bottomTrailing: .interactive,
                                                                      axis: .horizontal){ effect, phase in
                                                        effect
                                                            .scaleEffect(1 - abs(phase.value))
                                                            .opacity(1 - abs(phase.value))
                                                            .rotation3DEffect(.degrees(phase.value * 90), axis: (x: 0, y: -1, z: 0))
                                                    }
                                            }
                                            .frame(width: 300, height: 300)
                                            Text(product.name)
                                                .font(.headline)
                                                .padding(.horizontal, 40)
                                        }
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .frame(height: 200)
                        .safeAreaPadding(.horizontal, 52)
                        .scrollClipDisabled()
                        .scrollTargetBehavior(.viewAligned)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                    
                } else {
                    // Show button to buy ticket
                    Button(action: {
                        buyTicket()
                    }) {
                        Text("Buy Ticket")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            }
            .overlay(
                VStack {
                    if showToast {
                        Text("You do not have enough money")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                , alignment: .top
            )
            .onAppear{
                userWalletManager.fetchWalletBalance(for: viewModel.currentUser?.id ?? "")
            }
        }
    }
    
    func hasValidTicket() -> Bool {
        // Check if user has a valid ticket for this exhibition
        return tickets.contains(where: { $0.exhibitionName == entityName })
    }
    
    func buyTicket() {
        // Purchase a ticket for this exhibition and add it to the list
        let newTicket = Ticket(id: UUID().uuidString, exhibitionName: entityName)
        tickets.append(newTicket)
    }
    
}



class IsPaidManager: ObservableObject {
    @Published var isPaid: Bool = false
}


#Preview {
    ExhibitionView(isPaid: .constant(false), entityName: Entity.MOCK_ENTITY.entityName)
        .environmentObject(AuthViewModel())
        .environmentObject(UserWalletManager())
}
