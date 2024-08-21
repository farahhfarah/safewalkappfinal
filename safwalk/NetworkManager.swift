//
//  NetworkManager.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
//

import Foundation

class NetworkManager: ObservableObject {
    let baseURL = "http://localhost/safewalk/" // Using localhost for local development

    // Login function
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)login.php") else {
            print("Invalid URL")
            completion(false)
            return
        }

        // Parameters to send with the request
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Correct content type

        // Query string
        let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = queryString.data(using: .utf8)

        // Start the URL session data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Error handling
            if let error = error {
                print("Error during request: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check if data was received
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            // Decode response to string and check login success
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)") // Log the response
                completion(responseString == "success") // Return success or failure
            } else {
                print("Unable to decode response")
                completion(false)
            }
        }

        task.resume()
    }

    // Signup function
    func signup(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)signup.php") else {
            print("Invalid URL")
            completion(false)
            return
        }

        // Parameters to send with the request
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Correct content type

        // Create the query string
        let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = queryString.data(using: .utf8)

        // Start the URL session data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Error handling
            if let error = error {
                print("Error during request: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check if data was received
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            // Decode response to string and check signup success
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)") // Log the response
                completion(responseString == "success") // Return success or failure
            } else {
                print("Unable to decode response")
                completion(false)
            }
        }

        task.resume()
    }


// incident form
    
    func submitIncident(userid: String, time: String, date: String, location: String, details: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)submitincident.php") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        let parameters: [String: Any] = [
            "userid": userid,
            "time": time,
            "date": date,
            "location": location,
            "details": details
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during request: \(error)")
                completion(false)
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                print("No data received or unable to decode response")
                completion(false)
                return
            }
            
            if responseString == "success" {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
}

