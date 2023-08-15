//
//  LocationManager.swift
//  Mirage
//
//  Created by Saad on 10/04/2023.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    let locationManager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var elevation: Double?

    override init() {
        super.init()
        locationManager.desiredAccuracy = 5
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        requestAuthorizationIfNeeded()
    }

    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        elevation = locations.first?.altitude
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func requestAuthorizationIfNeeded() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            //we're good.
            locationManager.startUpdatingLocation()
        } else {
            requestLocation()
        }
            
    }
    @objc func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        switch manager.authorizationStatus {
        case .notDetermined:
            requestAuthorizationIfNeeded()
        case .restricted:
            // TODO: LocationManager - handle location restricted case
            print("Your location is restricted")
        case .denied:
            // TODO: LocationManager - setup alerts
            print("You have denied this app location permissions")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }

    }
    func shouldDisplayAccessAlert() -> Bool {
        let statusesToCheck: [CLAuthorizationStatus] = [.denied, .restricted]
        return statusesToCheck.contains(locationManager.authorizationStatus)
    }
    func alert() -> Alert {
        return Alert(title: Text("Location Restricted"),message: Text("Location is required to measure how far you are from Mira."),  primaryButton: .default(Text("Settings"), action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

        }), secondaryButton: .cancel())
    }
    
}
