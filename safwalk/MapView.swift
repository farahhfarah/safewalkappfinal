//
//  MapView.swift
//  safwalk
//
//
//
import SwiftUI
import MapKit

// Define a struct for your permanent markers
struct Marker: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    // Computed property to get CLLocationCoordinate2D from latitude and longitude
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.457122239782905, longitude: -0.2428900735927662), 
        // Default to Roehampton university
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    
    var userId: String
    
    
    let markers: [Marker] = [
        Marker(name: "Marker 1", latitude: 51.459458, longitude: -0.241048),
        Marker(name: "Marker 2", latitude: 51.457122, longitude: -0.242890),
        Marker(name: "Marker 3", latitude: 51.456122, longitude: -0.240890),
        Marker(name: "Marker 4", latitude: 51.458122, longitude: -0.239890),
        Marker(name: "Marker 5", latitude: 51.455122, longitude: -0.242890),
        Marker(name: "Marker 6", latitude: 51.459122, longitude: -0.244890),
        Marker(name: "Marker 7", latitude: 51.460122, longitude: -0.241890),
        Marker(name: "Marker 8", latitude: 51.461122, longitude: -0.240890),
        Marker(name: "Marker 9", latitude: 51.458122, longitude: -0.243890),
        Marker(name: "Marker 10", latitude: 51.457622, longitude: -0.245890),
    ]

    @State private var fetchedMarkers: [Marker] = []

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: markers + fetchedMarkers) { marker in
                    MapAnnotation(coordinate: marker.coordinate) {
                        Image("streetlamp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 3)
                    }
                }
                .ignoresSafeArea(edges: .top)

                // Emergency Button and Report Incident Button
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
                        NavigationLink(destination: IncidentReportView()) {
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
        .onAppear(perform: fetchMarkers)
    }

    func handleEmergency() {
        // Dial the emergency number
        if let url = URL(string: "tel://999") {
            UIApplication.shared.open(url)
        }

        
        let emergencyId = generateEmergencyId()

        
        storeEmergencyInDatabase(userId: userId, emergencyId: emergencyId)
    }

    func generateEmergencyId() -> Int {
        return Int.random(in: 1000...9999)
    }

    func storeEmergencyInDatabase(userId: String, emergencyId: Int) {
        let url = URL(string: "https://http://localhost/safewalk/emergency.php")!

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
            print("Emergency reported: User ID \(userId), Emergency ID \(emergencyId)")
        }.resume()
    }

    func fetchMarkers() {
        guard let url = URL(string: "http://localhost/safewalk/getincident.php") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching markers: \(error)")
                return
            }

            guard let data = data else { return }
            do {
                let markers = try JSONDecoder().decode([Marker].self, from: data)
                DispatchQueue.main.async {
                    self.fetchedMarkers = markers // Update the state with fetched markers
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView(userId: "1") // Example user ID for preview
        }
    }
}
