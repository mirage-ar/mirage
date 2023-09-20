//
//  MapApolloRepository.swift
//  Mirage
//
//  Created by Saad on 19/04/2023.
//

import Foundation
import Combine
import CoreLocation

protocol MapApolloRepository {
    
    func getMiras(location: CLLocationCoordinate2D, zoomLevel: Int) -> AnyPublisher<Array<Mira>?, Error>
    func subscribeToMiraAddChange() -> AnyPublisher<Mira, Error>
    
}

extension ApolloRepository: MapApolloRepository {
    func getMiras(location: CLLocationCoordinate2D, zoomLevel: Int = 7) -> AnyPublisher<Array<Mira>?, Error> {
        let locationInput = MirageAPI.LocationInput(latitude: location.latitude, longitude: location.longitude)
        let input = MirageAPI.GetMirasQueryInput(location: locationInput, zoomLevel: GraphQLNullable<Int>(integerLiteral: zoomLevel), radius: 3900000)
        let query = MirageAPI.GetMirasQuery(getMirasQueryInput: input)
        return fetch(query: query)
            .map {
                return $0.getMiras?.map({ mira in
                    return Mira(mira: mira)
                })
            }
            .eraseToAnyPublisher()
        
    }
    
    
    
    public func subscribeToMiraAddChange() -> AnyPublisher<Mira, Error> {
        if let subscription = miraAddSubscription {
            return subscription
        }
        
        let subscription = subscribe(to: MirageAPI.OnMiraAddSubscription(),
                                     subscriptionName: .miraAdded)
            .map({ data in
                Mira(mira: data.miraAdded)
            })
            .eraseToAnyPublisher()
        
        self.miraAddSubscription = subscription
        
        return subscription
    }
    
}

