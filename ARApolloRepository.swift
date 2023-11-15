//
//  ARApolloRepository.swift
//  Mirage
//
//  Created by fiigmnt on 7/11/23.
//

import ApolloAPI
import Combine
import CoreLocation
import Foundation
import simd

protocol ARApolloRepository {
    // TODO: should be moved up one level for broader use @saad
    func getARMiras(location: CLLocationCoordinate2D, zoomLevel: Int) -> AnyPublisher<[Mira]?, Error>
    func addMira(_ mira: Mira) -> AnyPublisher<[Mira]?, Error>
    func collectMira(id: UUID) -> AnyPublisher<Bool?, Error>
}

extension ApolloRepository: ARApolloRepository {
    func getARMiras(location: CLLocationCoordinate2D, zoomLevel: Int = 7) -> AnyPublisher<[Mira]?, Error> {
        let locationInput = MirageAPI.LocationInput(latitude: location.latitude, longitude: location.longitude)
        // Query all miras within a 50 meter radius
        let input = MirageAPI.GetMirasQueryInput(location: locationInput, radius: 50)
        let query = MirageAPI.GetMirasQuery(getMirasQueryInput: input)
        return fetch(query: query)
            .map {
                return $0.getMiras?.map { mira in
                    Mira(mira: mira)
                }
            }
            .eraseToAnyPublisher()
    }

    func addMira(_ mira: Mira) -> AnyPublisher<[Mira]?, Error> {
        let location = MirageAPI.LocationInput(latitude: mira.location.latitude, longitude: mira.location.longitude, elevation: mira.elevation ?? nil, heading: mira.heading ?? nil)
        let arMedia = mira.arMedia.map { media in
            let position = MirageAPI.PositionInput(transform: convertTo2DArray(media.transform))
            let modifier = MirageAPI.ModifierInput(type: GraphQLEnum(media.modifier.rawValue), amount: 1.0)
            let nullableModifier = GraphQLNullable<MirageAPI.ModifierInput>.some(modifier)
            return MirageAPI.ArMediaInput(contentType: GraphQLEnum(media.contentType.rawValue), assetUrl: media.assetUrl, shape: GraphQLEnum(media.shape.rawValue), position: position, modifier: nullableModifier)
        }
        let input = MirageAPI.AddMiraInput(location: location, arMedia: arMedia)
        let mutation = MirageAPI.AddMiraMutation(addMiraInput: input)
        return performAppsync(mutation: mutation)
            .map { data in
                // assuming that 'addMira' is a property that returns an array of Mira
                // and 'Mira' is a type that has an initializer accepting a 'Mira'
                data.addMira.map { [Mira(mira: $0)] }
            }
            .eraseToAnyPublisher()
    }
    
    func collectMira(id: UUID) -> AnyPublisher<Bool?, Error> {
        let input = MirageAPI.CollectMiraInput(miraId: id.uuidString)
        let mutation = MirageAPI.CollectMiraMutation(collectMiraInput: input)
        
        // convert to result boolean
        // TODO: update collected value
        return perform(mutation: mutation)
            .map { data in
                // if successful mutation
                return true
            }
            .eraseToAnyPublisher()
    }
}

func convertTo2DArray(_ matrix: simd_float4x4) -> [[Double]] {
    var result: [[Double]] = []

    for i in 0..<4 {
        var row: [Double] = []
        for j in 0..<4 {
            row.append(Double(matrix[i][j]))
        }
        result.append(row)
    }

    return result
}
