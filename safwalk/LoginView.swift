//
//  LoginView.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginSuccessful = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Login") {
                NetworkManager().login(email: email, password: password) { success in
                    if success {
                        DispatchQueue.main.async {
                            loginSuccessful = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            errorMessage = "Login failed. Please check your credentials."
                        }
                    }
                }
            }
            .padding()

            if loginSuccessful {
                Text("Login Successful!")
                    .foregroundColor(.green)
            } else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
