//
//  SignupView.swift
//  safwalk
//
// 
//

import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var signupSuccessful = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                NetworkManager().signup(email: email, password: password) { success in
                    if success {
                        DispatchQueue.main.async {
                            signupSuccessful = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            errorMessage = "Signup failed. Please try again."
                        }
                    }
                }
            }
            .padding()

            if signupSuccessful {
                Text("Signup Successful!")
                    .foregroundColor(.green)
            } else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
