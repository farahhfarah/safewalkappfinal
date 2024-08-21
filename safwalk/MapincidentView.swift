//
//  MapincidentView.swift
//  safwalk
//
//  Created by F Farah on 21/08/2024.
//

import Foundation
import CoreLocation

struct Incident: Identifiable, Codable {
    let id = UUID()
    let incidentid: String
    let time: String
    let date: String
    let location: String
    let details: String
    let userid: String
    
    var coordinate: CLLocationCoordinate2D {
        let parts = location.split(separator: ",").map { Double($0.trimmingCharacters(in: .whitespaces)) }
        if let lat = parts.first, let lon = parts.last {
            return CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lon ?? 0)
        } else {
            return CLLocationCoordinate2D()
        }
    }
}
