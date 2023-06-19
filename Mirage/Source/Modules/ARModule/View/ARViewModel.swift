//
//  ARCameraViewModel.swift
//  Mirage
//
//  Created by fiigmnt on 6/7/23.
//

import SwiftUI
import RealityKit
import ARKit

final class ARCameraViewModel: ObservableObject {

    // AR related data
    var arView: ARView? = nil
    
    // Function to set world tracking configuration
    func setWorldTracking() {
        guard let arView = self.arView else {
            print("ERROR: No ARView found in ARCameraViewModel")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()        
        arView.session.run(configuration)
    }

    // Function to set geo tracking configuration
    func setGeoTracking() {
        guard let arView = self.arView else {
            print("ERROR: No ARView found in ARCameraViewModel")
            return
        }
        
        guard ARGeoTrackingConfiguration.isSupported else {
            print("ERROR: Geo tracking not supported on this device")
            return
        }

        let configuration = ARGeoTrackingConfiguration()
        arView.session.run(configuration)
    }
    
    
    
}
