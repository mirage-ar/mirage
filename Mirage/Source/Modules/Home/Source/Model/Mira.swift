//
//  Mira.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import Foundation
import CoreLocation

struct Mira: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

extension Mira {
    static func dummyMiras() -> [Mira] {
        let miras = [
            Mira(name: "Mirage Palace", coordinate: CLLocationCoordinate2D(latitude: 40.710610, longitude: -73.915242)),
            Mira(name: "Tower of Mira", coordinate: CLLocationCoordinate2D(latitude: 40.750610, longitude: -73.932842)),
            Mira(name: "Mirage Palace", coordinate: CLLocationCoordinate2D(latitude: 40.790610, longitude: -73.915242)),
            Mira(name: "Tower of Mira", coordinate: CLLocationCoordinate2D(latitude: 40.740610, longitude: -73.935242)),
            Mira(name: "Mirage Palace", coordinate: CLLocationCoordinate2D(latitude: 40.710910, longitude: -73.915942)),
            Mira(name: "Tower of Mira", coordinate: CLLocationCoordinate2D(latitude: 40.750110, longitude: -73.935012))
        ]
        return miras
    }
}
