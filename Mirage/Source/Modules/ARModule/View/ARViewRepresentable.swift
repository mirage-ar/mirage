//
//  ARViewRepresentable.swift
//  Miras
//
//  Created by fiigmnt on 2/13/23.
//

import ARKit
import RealityKit
import SwiftUI

struct ARViewRepresentable: UIViewRepresentable {
    @StateObject var viewModel: ARViewModel
    
    @State var miraAdded: Bool = false
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARViewController {
        let arView = viewModel.arView
        arView.automaticallyConfigureSession = false
        
        setupARViewConfiguration(arView)
        
        // Setup scene observer
        viewModel.sceneData.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            updateScene(for: arView)
        }
        
        // Initialize sceneData on view model
        viewModel.initializSceneData(arView: arView)
        
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ arView: ARViewController, context: Context) {
        // if view mode has changed update configuration
        if !viewModel.arViewLocalized {
            setupARViewConfiguration(arView)
        }
    }
    
    private func updateScene(for arView: ARViewController) {
//        guard let selectedEntity = viewModel.sceneData.selectedEntity else { return }
//
//        if let entity = selectedEntity.entity as? HasCollision {
//            // Extract the translation components from both transforms
//            let entityPosition = entity.transform.translation
//            let cameraPosition = arView.cameraTransform.translation
//
//            // Calculate the distance between the two positions
//            let distance = simd_distance(entityPosition, cameraPosition)
//            let entityScale = entity.scale.x
//            let multiplier = 1.5 * entityScale > 80 ? 80 : entityScale
//
//            if distance > multiplier, selectedEntity.withinBounds {
//                // select translation gesture from MediaEntity
//                guard let translationGesture = selectedEntity.translationGesture else { return }
//                let recognizerIndex = arView.gestureRecognizers?.firstIndex(of: translationGesture)
//
//                // remove translation gesture from the view
//                guard let recognizerIndex = recognizerIndex else { return }
//                arView.gestureRecognizers?.remove(at: recognizerIndex)
//
//                // update MediaEntity properties
//                // TODO: change these updates to method on MediaEntity
//                viewModel.sceneData.selectedEntity?.withinBounds = false
//                //                stateManager.sceneData.selectedEntity?.translationGesture = nil
//                let newTranslationGesture = arView.installGestures(.translation, for: entity).first
//                viewModel.sceneData.selectedEntity?.translationGesture = newTranslationGesture
//
//                viewModel.triggerHapticFeedback()
//
//            } else if distance < multiplier, !selectedEntity.withinBounds {
//                viewModel.sceneData.selectedEntity?.withinBounds = true
//            }
//        }
    }
    
    func setupARViewConfiguration(_ arView: ARViewController) {
        let currentConfiguration = arView.session.configuration
        
        if viewModel.arViewMode == .EXPLORE && !(currentConfiguration is ARGeoTrackingConfiguration) {
            ARGeoTrackingConfiguration.checkAvailability { isAvailable, _ in
                
                DispatchQueue.main.async {
                    if ARGeoTrackingConfiguration.isSupported && isAvailable {
                        print("UPDATE: AR configuration changed to GEO TRACKING")
                        let configuration = ARGeoTrackingConfiguration()
                            
                        // Enable coaching.
                        arView.setupCoachingOverlay()
                            
                        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                    } else {
                        print("ERROR: Geo tracking not supported on this device")
                        viewModel.arViewMode = .CREATE
                    }
                }
            }
        }
            
        if viewModel.arViewMode == .CREATE && !(currentConfiguration is ARWorldTrackingConfiguration) {
            print("UPDATE: AR configuration changed to WORLD TRACKING")
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
                
            // Check for LiDAR support
            if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                arView.environment.sceneUnderstanding.options.insert(.occlusion)
            }
                
            // Check for person segmentation with depth support
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                configuration.frameSemantics.insert(.personSegmentationWithDepth)
            }
                
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewRepresentable
        
        var addedMiras: Bool = false
        
        init(_ parent: ARViewRepresentable) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            print("ADDED")
            for anchor in anchors {
                print(anchor.name)
            }
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {}
        
        func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
            if geoTrackingStatus.state == .localized {
                print("UPDATE: ARGeo Session Localized")
                print(parent.miraAdded)
                parent.viewModel.arViewLocalized = true
                if !parent.miraAdded {
                    parent.viewModel.addMiraToScene()
                    parent.miraAdded = true
                }
            } else {
                parent.viewModel.arViewLocalized = false
            }
        }

        func isGeoTrackingLocalized(_ session: ARSession) -> Bool {
            if let status = session.currentFrame?.geoTrackingStatus, status.state == .localized {
                return true
            }
            return false
        }
    }
}
