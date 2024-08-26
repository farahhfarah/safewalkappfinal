//
//  ContentView.swift
//  safwalk
//

//

import SwiftUI

struct SafeWalkApp: App {
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

