//
//  ExhibitionView.swift
//  ArtMarketplace
//
//  Created by Horia Stefan Munteanu on 06.03.2024.
//

import SwiftUI
import URLImage

struct ExhibitionView: View {
    @ObservedObject private var productManager = ProductManager()
    @ObservedObject var userWalletManager: UserWalletManager
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showToast = false
    @State private var isPaid = false
    var exhibitionPrice = 20
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                VStack(alignment: .leading){
                    if !isPaid {
                        Button(action: {
                            if Double(exhibitionPrice) <= userWalletManager.walletBalance {
                                userWalletManager.withdrawWalletBalanceInFirestore(withAmount: Double(exhibitionPrice))
                                userWalletManager.recordTransaction(type: "Exhibition ticket", amount: Double(exhibitionPrice))
                                isPaid = true
                            } else {
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                        }) {
                            Text("Pay $20 to enter")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    
                    if isPaid {
                        VStack{
                            NavigationLink(destination: PremiumExhibitionView()){
                                Text("Visit premium exhibition")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                            Spacer()
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(productManager.productList.filter { $0.label == "standard" }) { product in
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
                                .scrollTargetLayout()
                            }
                            .frame(height: 200)
                            .safeAreaPadding(.horizontal, 52)
                            .scrollClipDisabled()
                            .scrollTargetBehavior(.viewAligned)
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    userWalletManager.fetchWalletBalance(for: viewModel.currentUser?.id ?? "")
                    //  userWalletManager.fetchWalletBalance(for: String(User.MOCK_USER.wallet))
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
        }
    }
}

#Preview {
    ExhibitionView(userWalletManager: UserWalletManager())
        .environmentObject(AuthViewModel())
}
