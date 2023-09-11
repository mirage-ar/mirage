//
//  LocationManager.swift
//  Mirage
//
//  Created by Saad on 10/04/2023.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var elevation: Double?
    @Published var heading: Double?

    override init() {
        super.init()
        locationManager.delegate = self

//        locationManager.desiredAccuracy = 5
//        locationManager.distanceFilter = 100

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        requestAuthorizationIfNeeded()
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        elevation = locations.first?.altitude
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        locationManager.stopUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func requestAuthorizationIfNeeded() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse
        {
            // we're good.
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()

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
}
