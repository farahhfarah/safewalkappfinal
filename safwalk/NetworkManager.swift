//
//  NetworkManager.swift
//  safwalk
//
//
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
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = queryString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during request: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
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
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = queryString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Error handling
            if let error = error {
                print("Error during request: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
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
            
            if let jsonData = responseString.data(using: .utf8) {
                do {
                    
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
