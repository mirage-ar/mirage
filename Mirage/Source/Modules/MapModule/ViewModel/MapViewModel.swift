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
        getMiras(location: CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.91524212298014), zoomLevel: 7)
    }
    
    func update() {
        if var tempMira = miras?.last {
            tempMira.location = CLLocationCoordinate2D(latitude: tempMira.location.latitude + 0.0004, longitude: tempMira.location.longitude + 0.00005)
            DispatchQueue.main.async {
                self.miras = [tempMira]
                self.hasLoadedMiras = true
                self.isLoading = false

                
            }

        }
    }
    func getMiras(location: CLLocationCoordinate2D, zoomLevel: Int) {
        mapApolloRepository.getMiras(location: location, zoomLevel: zoomLevel)
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
