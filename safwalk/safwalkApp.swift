//
//  safwalkApp.swift
//  safwalk
//
//  
//

import SwiftUI

@main
struct SafWalkApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                LoginView()
                    .tabItem {
                        Label("Login", systemImage: "person.fill")
                    }

                SignupView()
                    .tabItem {
                        Label("Sign Up", systemImage: "plus.app.fill")
                    }
            }
        }
    }
}
