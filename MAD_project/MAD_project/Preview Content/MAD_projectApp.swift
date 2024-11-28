//
//  MAD_projectApp.swift
//  MAD_project
//
//  Created by Christian LeMay on 10/16/24.
//

import SwiftUI
import FirebaseCore

@main
struct Mad_project: App {
    
    @StateObject private var authManager = AuthManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if authManager.user != nil {
                    HomeView()
                        .environmentObject(authManager)
                } else {
                    LogInView()
                        .environmentObject(authManager)
                }
            }
        }
    }
}
