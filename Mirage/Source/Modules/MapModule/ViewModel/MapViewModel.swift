//
//  MapViewModel.swift
//  Mirage
//
//  Created by Saad on 20/04/2023.
//

import Foundation
import CoreLocation

final class MapViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var hasLoadedMiras = false
    @Published var miras: [Mira]?

    let mapApolloRepository: MapApolloRepository = AppConfiguration.shared.apollo

    init() {
        getMiras(location: CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.91524212298014), userId: "0", accessToken: "0")
    }

    func getMiras(location: CLLocationCoordinate2D, userId: String, accessToken: String) {
        mapApolloRepository.getMiras(location: location, userId: userId, accessToken: accessToken)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel(receiveOutput: { miras in
                self.miras = miras
                self.hasLoadedMiras = true
                self.isLoading = false
            }, receiveError: { error in
                print("Error: \(error)")
                self.isLoading = false
            })
    }
}
