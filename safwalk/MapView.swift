//
//  MapView.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    let incidents: [Incident] // Assuming this is passed from a parent view or fetched from the NetworkManager
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: incidents) { incident in
            MapAnnotation(coordinate: incident.coordinate) {
                // Customize the annotation view, e.g., a red flag
                Image(systemName: "flag.fill")
                    .foregroundColor(.red)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(incidents: [
            Incident(incidentid: "1", time: "10:00 AM", date: "2024-08-21", location: "37.7749,-122.4194", details: "Example incident", userid: "1")
        ])
    }
}
