//
//  ContentView.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 10.11.2023.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var productManager = ProductManager()
    @ObservedObject var userWalletManager = UserWalletManager()
    @State var currentTab: Tab = .Home
    @State private var isActive = true
    @Namespace var animation
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                TabView(selection: $currentTab){
                    HomePageView()
                        .environmentObject(productManager)
                        .tag(Tab.Home)
                    
                    ExhibitionView(userWalletManager: UserWalletManager())
                        .environmentObject(viewModel)
                        .tag(Tab.Exhibition)
                    
                    OrdersView()
                        .environmentObject(viewModel)
                        .tag(Tab.Orders)
                    
                    CartView()
                        .environmentObject(productManager)
                        .environmentObject(viewModel)
                        .tag(Tab.Cart)

                    ProfileView()
                        .environmentObject(productManager)
                        .tag(Tab.Profile)
                }
                .overlay(
                    HStack(spacing:0){
                        ForEach(Tab.allCases, id: \.rawValue){tab in
                            TabButton(tab: tab)
                        }
                        .padding(.vertical)
                        .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 15))
                        .background(Color("kSecondary"))
                    }
                    , alignment: .bottom
                )
                .ignoresSafeArea(.all, edges: .bottom)
               // LoginView()
            } else {
                LoginView()
            }
        }
    }
    
    func TabButton(tab: Tab) -> some View {
       
        GeometryReader{proxy in
            Button(action: {
                withAnimation(.spring()){
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0){
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill" : tab.rawValue)
                        .resizable()
                        .foregroundColor(Color("kPrimary"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack{
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "Tab", in: animation)
                                    
                                    Text(tab.TabName)
                                        .foregroundColor(.primary)
                                        .font(.footnote)
                                        .padding(.top, 50)
                                }
                                
                                if tab == .Cart {
                                    ZStack(alignment: .topTrailing){
                                        if let currentUser = viewModel.currentUser {
                                            if let userCart = productManager.userCarts[currentUser.id], userCart.count > 0 {
                                                Text("\(userCart.count)")
                                                    .font(.caption2)
                                                    .foregroundColor(.white)
                                                    .frame(width: 15, height: 15)
                                                    .background(Color("kPrimary"))
                                                    .cornerRadius(50)
                                                    .offset(x: 10, y:-9)
                                            }
                                        }
                                    }

                                }
                            }
                        ).contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -15 : 0)
                }
            })
        }
        .frame(height: 25)
    }
}

enum Tab: String, CaseIterable{
    case Home = "house"
    case Exhibition = "photo.stack"
    case Orders = "book.pages"
    case Cart = "bag"
    case Profile = "person"
    
    var TabName: String {
        switch self {
        case .Home:
            return "Home"
        case .Exhibition:
            return "Exhibition"
        case .Orders:
            return "Orders"
        case .Cart:
            return "Cart"
        case .Profile:
            return "Profile"
        }
    }
}

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as?
                UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else  {
            return .zero
        }
        
        return safeArea
    }
}

struct MaterialEffect: UIViewRepresentable{
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

#Preview {
    ContentView()
        .environmentObject(ProductManager())
        .environmentObject(AuthViewModel())

}
