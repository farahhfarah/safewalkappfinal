//
//  LoginView.swift
//  safwalk
//
//  
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginSuccessful = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200) // Adjust height as needed
                    .padding()

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
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                    let window = windowScene.windows.first
                                    window?.rootViewController = UIHostingController(rootView: MapView(userId: email)) // Assuming userId is the email
                                    window?.makeKeyAndVisible()
                                }
                            }
                        }
                } else if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
}
// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
