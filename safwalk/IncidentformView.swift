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
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        Form {
            Section(header: Text("Incident Information")) {
                TextField("User ID", text: $userid)
                TextField("Time", text: $time)
                TextField("Date", text: $date)
                TextField("Location", text: $location)
                TextField("Details", text: $details)
            }
            
            Button(action: {
                // Call the function to submit the incident report
                networkManager.submitIncident(userid: userid, time: time, date: date, location: location, details: details) { success in
                    if success {
                        alertMessage = "Incident reported successfully!"
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

struct IncidentReportView_Previews: PreviewProvider {
    static var previews: some View {
        IncidentReportView()
    }
}
