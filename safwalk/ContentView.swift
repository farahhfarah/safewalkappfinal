//
//  ContentView.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
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

