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
    
    let mapApolloRepository: MapApolloRepository = AppConfiguration.shared.apollo
    let authRepo: AuthenticationRepository = AppConfiguration.shared.apollo

    func getMiras(location: CLLocationCoordinate2D, userId: String, accessToken: String) {
        mapApolloRepository.getMiras(location: location, userId: userId, accessToken: accessToken)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel(receiveOutput: {
                print("Miras \($0)")
                self.isLoading = false
            }, receiveError: { error in
                print("Error: \(error)")
            })
        
//        self.isLoading = true
        
    }
}
