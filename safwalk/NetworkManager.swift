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
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

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
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

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

    // Incident form submission
    func submitIncident(userid: String, time: String, date: String, location: String, details: String, completion: @escaping (Bool, Int?) -> Void) {
        guard let url = URL(string: "\(baseURL)submitincident.php") else {
            print("Invalid URL")
            completion(false, nil)
            return
        }

        // Prepare parameters for form submission
        let parameters: [String: Any] = [
            "userid": userid,
            "time": time,
            "date": date,
            "location": location,
            "details": details
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Create query string from parameters
        let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = queryString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during request: \(error)")
                completion(false, nil)
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                print("No data received or unable to decode response")
                completion(false, nil)
                return
            }

            // Handle response to extract incidentid
            if let jsonData = responseString.data(using: .utf8) {
                do {
                    // Decode JSON response
                    if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let success = jsonResponse["success"] as? Bool,
                       let incidentid = jsonResponse["incidentid"] as? Int {
                        completion(success, incidentid)
                    } else {
                        completion(false, nil)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }

        task.resume()
    }
}
