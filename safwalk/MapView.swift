//
//  MapView.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
//

import SwiftUI
import MapKit

// Define a struct for your permanent markers
struct Marker: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.457122239782905, longitude: -0.2428900735927662), // Default to Roehampton university
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    // User ID of the currently logged-in user
    var userId: String // Replace with the actual user ID from your authentication system
    
    // Define your custom markers with specific locations
    let markers: [Marker] = [
        Marker(name: "Marker 1", coordinate: CLLocationCoordinate2D(latitude: 51.459458, longitude: -0.241048)),
        Marker(name: "Marker 2", coordinate: CLLocationCoordinate2D(latitude: 51.457122, longitude: -0.242890)),
        Marker(name: "Marker 3", coordinate: CLLocationCoordinate2D(latitude: 51.456122, longitude: -0.240890)),
        Marker(name: "Marker 4", coordinate: CLLocationCoordinate2D(latitude: 51.458122, longitude: -0.239890)),
        Marker(name: "Marker 5", coordinate: CLLocationCoordinate2D(latitude: 51.455122, longitude: -0.242890)),
        Marker(name: "Marker 6", coordinate: CLLocationCoordinate2D(latitude: 51.459122, longitude: -0.244890)),
        Marker(name: "Marker 7", coordinate: CLLocationCoordinate2D(latitude: 51.460122, longitude: -0.241890)),
        Marker(name: "Marker 8", coordinate: CLLocationCoordinate2D(latitude: 51.461122, longitude: -0.240890)),
        Marker(name: "Marker 9", coordinate: CLLocationCoordinate2D(latitude: 51.458122, longitude: -0.243890)),
        Marker(name: "Marker 10", coordinate: CLLocationCoordinate2D(latitude: 51.457622, longitude: -0.245890)),
    ]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: markers) { marker in
                MapAnnotation(coordinate: marker.coordinate) {
                    // Customize the annotation view with your custom marker image
                    Image("streetlamp") // Make sure the image is added to your Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40) // Adjust size as needed
                        .shadow(radius: 3) // Optional shadow for better visibility
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Emergency Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    // Emergency Button
                    Button(action: handleEmergency) {
                        Text("Emergency")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // Report Incident Button
                    NavigationLink(destination: IncidentFormView(userId: userId)) {
                        Text("Report Incident")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }

    func handleEmergency() {
        // Dial the emergency number
        if let url = URL(string: "tel://999") {
            UIApplication.shared.open(url)
        }

        // Generate a unique emergency ID
        let emergencyId = generateEmergencyId()

        // Store the user ID and emergency ID in the incidents table
        storeEmergencyInDatabase(userId: userId, emergencyId: emergencyId)
    }

    func generateEmergencyId() -> Int {
        return Int.random(in: 1000...9999) // Generate a random number between 1000 and 9999
    }

    func storeEmergencyInDatabase(userId: String, emergencyId: Int) {
        let url = URL(string: "https://your-server.com/emergencybutton.php")! // Replace with your actual PHP URL

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "userid=\(userId)&emergencyid=\(emergencyId)"
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            // Handle the response if needed
            print("Emergency reported: User ID \(userId), Emergency ID \(emergencyId)")
        }.resume()
    }
}

// Previews for your MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(userId: "1") // Example user ID for preview
    }
}

// Dummy IncidentFormView for navigation
struct IncidentFormView: View {
    var userId: String // Assuming userId is passed to this view
    
    var body: some View {
        VStack {
            Text("Incident Form for User ID: \(userId)")
                .font(.title)
                .padding()
            // Additional form elements can be added here
        }
        .navigationTitle("Report Incident")
    }
}
