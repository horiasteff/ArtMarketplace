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
    var body: some View {
        ZStack{
            Color("kSecondary").ignoresSafeArea()
            VStack(alignment: .leading){
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(productManager.productList) { product in
                            VStack{
                                URLImage(product.image) { image in
                                    image
                                        .resizable()
                                        .cornerRadius(15)
                                        .frame(width: 200, height: 200)
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
                                Text(product.name)
                                    .font(.headline)
                                    .padding(.horizontal, 40)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .frame(height: 200)
                .safeAreaPadding(.horizontal, 32)
                .scrollClipDisabled()
                .scrollTargetBehavior(.viewAligned)
            }
//            .background(Color("kPrimary"))
//            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    ExhibitionView()
}
