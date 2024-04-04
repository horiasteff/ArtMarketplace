//
//  PremiumExhibitionView.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 04.04.2024.
//

import SwiftUI
import URLImage

struct PremiumExhibitionView: View {
    @ObservedObject private var productManager = ProductManager()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("kPrimary").opacity(1), Color("kPrimary").opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(productManager.productList.filter { $0.label == "premium" }) { product in
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
        }
    }
}

#Preview {
    PremiumExhibitionView()
}
