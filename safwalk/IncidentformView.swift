//
//  IncidentformView.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
//

import SwiftUI
import MapKit

struct IncidentReportView: View {
    @State private var userid: String = ""
    @State private var time: String = ""
    @State private var date: String = ""
    @State private var location: String = ""
    @State private var details: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // State variable for map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.457122239782905, longitude: -0.2428900735927662), // Default to Roehampton university
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    // State variable for selected coordinate
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack {
            // Map view
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .gesture(TapGesture().onEnded { value in
                    // Get the location of the tap
                    let locationCoordinate = region.center // This is a placeholder
                    location = "\(locationCoordinate.latitude), \(locationCoordinate.longitude)" // Update the location text field with coordinates
                })
                .frame(height: 300) // Set height for the map
            
            Form {
                Section(header: Text("Incident Information")) {
                    TextField("User ID", text: $userid)
                    TextField("Time", text: $time)
                    TextField("Date", text: $date)
                    TextField("Location", text: $location)
                        .disabled(true) // Disable user input for location since it will be set by the map
                    TextField("Details", text: $details)
                }
                
                Button(action: {
                    // Validate inputs
                    guard !userid.isEmpty, !time.isEmpty, !date.isEmpty, !location.isEmpty, !details.isEmpty else {
                        alertMessage = "All fields are required."
                        showAlert = true
                        return
                    }

                    // Call the function to submit the incident report
                    networkManager.submitIncident(userid: userid, time: time, date: date, location: location, details: details) { success, incidentID in
                        if success {
                            alertMessage = "Incident reported successfully! Incident ID: \(incidentID ?? 0)"
                        } else {
                            alertMessage = "Failed to report incident. Please try again."
                        }
                        showAlert = true
                    }
                }) {
                    Text("Submit")
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertMessage))
                }
            }
            .navigationTitle("Report an Incident")
        }
    }
}

struct IncidentReportView_Previews: PreviewProvider {
    static var previews: some View {
        IncidentReportView()
    }
}
