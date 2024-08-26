//
//  IncidentformView.swift
//  safwalk
//
//  
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
    
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.457122239782905, longitude: -0.2428900735927662), // Default to Roehampton university
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack {
            // Map view
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .gesture(TapGesture().onEnded { value in
                   
                    let locationCoordinate = region.center
                    location = "\(locationCoordinate.latitude), \(locationCoordinate.longitude)"
                })
                .frame(height: 300)
            
            Form {
                Section(header: Text("Incident Information")) {
                    TextField("User ID", text: $userid)
                    TextField("Time", text: $time)
                    TextField("Date", text: $date)
                    TextField("Location", text: $location)
                        .disabled(true)
                    TextField("Details", text: $details)
                }
                
                Button(action: {
                    
                    guard !userid.isEmpty, !time.isEmpty, !date.isEmpty, !location.isEmpty, !details.isEmpty else {
                        alertMessage = "All fields are required."
                        showAlert = true
                        return
                    }

                    
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
