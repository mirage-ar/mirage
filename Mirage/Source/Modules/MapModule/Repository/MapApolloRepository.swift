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
    
    func getMiras(location: CLLocationCoordinate2D, userId: String, accessToken: String) -> AnyPublisher<Array<MirageAPI.MapQuery.Data.Map?>, Error>

}

extension ApolloRepository: MapApolloRepository {
    public func getMiras(location: CLLocationCoordinate2D, userId: String, accessToken: String) -> AnyPublisher<Array<MirageAPI.MapQuery.Data.Map?>, Error> {
        let locationInput = MirageAPI.LocationInput(latitude: location.latitude, longitude: location.longitude)
        let id = MirageAPI.ID()
        let input = MirageAPI.MapQueryInput(userId: "", accessToken: accessToken, location: locationInput)
        let query = MirageAPI.MapQuery(mapQueryInput: input)
        return fetch(query: query)
            .map {
                print("here: \($0)")
                //TODO: update to user model
                return $0.map ?? []
            }
            .eraseToAnyPublisher()

    }
}
