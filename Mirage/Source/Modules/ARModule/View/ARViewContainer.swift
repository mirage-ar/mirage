//
//  ARViewRepresentable.swift
//  Mirage
//
//  Created by fiigmnt on 7/20/22.
//

import ARKit
import RealityKit
import SwiftUI


struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var stateManager: StateManager
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARViewController {
        let arView = ARViewController(frame: .zero)
        arView.session.delegate = context.coordinator
        
        // Enable coaching.
        arView.setupCoachingOverlay()
        
        return arView
    }
    
    // Update view on binding or state changes
    func updateUIView(_ arView: ARViewController, context: Context) {

    }
    
    // Update scene on every frame
    private func updateScene(for arView: ARViewController) {
        
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {

        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {}
        
        func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
            if geoTrackingStatus.state == .localized {
                print("HEREHERE")
                parent.stateManager.arViewLocalized = true
            } else {
                parent.stateManager.arViewLocalized = false
            }
        }

        func isGeoTrackingLocalized(_ session: ARSession) -> Bool {
            if let status = session.currentFrame?.geoTrackingStatus, status.state == .localized {
                print("LOCALIZED")
                return true
            }
            return false
        }
    }
}
