//
//  ArtMarketplaceApp.swift
//  ArtMarketplace
//
//  Created by Horia Munteanu on 10.11.2023.
//

import SwiftUI
import Firebase

@main
struct ArtMarketplaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = AuthViewModel()
    
    
    var body: some Scene {
        WindowGroup {
           
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
