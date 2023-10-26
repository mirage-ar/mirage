//
//  MapViewModel.swift
//  Mirage
//
//  Created by Saad on 20/04/2023.
//

import CoreLocation
import Foundation

final class MapViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var hasLoadedMiras = false
    @Published var miras: [Mira]?

    let mapApolloRepository: MapApolloRepository = AppConfiguration.shared.apollo

    init() {
        print("INIT MAP VIEW MODEL")
        getMiras(location: LocationManager.shared.location ?? CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.91524212298014), zoomLevel: 7)
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

    func handleMiraAdded(mira: Mira?) {
        guard let mira = mira else { return }
        var tempArray = self.miras
        tempArray?.append(mira)
        self.miras = tempArray
    }
}
