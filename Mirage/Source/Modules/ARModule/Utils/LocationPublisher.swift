//
//  LocationPublisher.swift
//  Mirage
//
//  Created by fiigmnt on 9/7/23.
//

import Combine
import CoreLocation

struct LocationData {
    let location: CLLocation
    let heading: CLHeading
    let elevation: Double
}

class LocationPublisher: NSObject, CLLocationManagerDelegate, Publisher {
    typealias Output = LocationData
    typealias Failure = Never

    private var locationManager = CLLocationManager()
    private var subscribers: [AnySubscriber<Output, Failure>] = []
    
    private var currentLocation: CLLocation?
    private var currentHeading: CLHeading?
    private var currentElevation: Double?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = LocationSubscription(subscriber: subscriber, locationManager: locationManager)
        subscribers.append(AnySubscriber(subscriber))
        subscriber.receive(subscription: subscription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            currentElevation = location.altitude
            publishIfAllAvailable()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading
        publishIfAllAvailable()
    }

    private func publishIfAllAvailable() {
        if let location = currentLocation, let heading = currentHeading, let elevation = currentElevation {
            let data = LocationData(location: location, heading: heading, elevation: elevation)
            _ = subscribers.map { $0.receive(data) }
            
            // Clearing the values to avoid sending the same data multiple times
            currentLocation = nil
            currentHeading = nil
            currentElevation = nil
        }
    }
}

final class LocationSubscription<S: Subscriber>: Subscription where S.Input == LocationData, S.Failure == Never {
    private var subscriber: S?
    private var locationManager: CLLocationManager
    
    init(subscriber: S, locationManager: CLLocationManager) {
        self.subscriber = subscriber
        self.locationManager = locationManager
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        subscriber = nil
    }
}
