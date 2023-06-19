//
//  ARViewRepresentable.swift
//  Miras
//
//  Created by fiigmnt on 2/13/23.
//

import ARKit
import RealityKit
import SwiftUI

struct ARViewCreateRepresentable: UIViewRepresentable {
    @StateObject var viewModel: ARCameraViewModel
    
    @EnvironmentObject var stateManager: StateManager
    let view: ARView
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    func makeUIView(context: Context) -> ARView {
        return setupARView(view)
    }
    
    func updateUIView(_ arView: ARView, context: Context) {}
    
    private func updateScene(for arView: ARView) {
        guard let selectedEntity = stateManager.sceneData.selectedEntity else { return }
        
        if let entity = selectedEntity.entity as? HasCollision {
            // Extract the translation components from both transforms
            let entityPosition = entity.transform.translation
            let cameraPosition = arView.cameraTransform.translation
            
            // Calculate the distance between the two positions
            let distance = simd_distance(entityPosition, cameraPosition)
            let entityScale = entity.scale.x
            let multiplier = 1.5 * entityScale > 80 ? 80 : entityScale
            
            if distance > multiplier, selectedEntity.withinBounds {
                // select translation gesture from MediaEntity
                guard let translationGesture = selectedEntity.translationGesture else { return }
                let recognizerIndex = arView.gestureRecognizers?.firstIndex(of: translationGesture)
                
                // remove translation gesture from the view
                guard let recognizerIndex = recognizerIndex else { return }
                arView.gestureRecognizers?.remove(at: recognizerIndex)
                
                // update MediaEntity properties
                // TODO: change these updates to method on MediaEntity
                stateManager.sceneData.selectedEntity?.withinBounds = false
                //                stateManager.sceneData.selectedEntity?.translationGesture = nil
                let newTranslationGesture = arView.installGestures(.translation, for: entity).first
                stateManager.sceneData.selectedEntity?.translationGesture = newTranslationGesture
                
                triggerHapticFeedback()
                
            } else if distance < multiplier, !selectedEntity.withinBounds {
                stateManager.sceneData.selectedEntity?.withinBounds = true
            }
        }
    }
    
    func setupARView(_ arView: ARView) -> ARView {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()

        // Check for LiDAR support
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            // TODO: add user action to show or hide mesh
            configuration.sceneReconstruction = .mesh
//            arView.debugOptions.insert(.showSceneUnderstanding)
            arView.environment.sceneUnderstanding.options.insert(.occlusion)
        }

        configuration.planeDetection = [.horizontal]

        // Check for person segmentation with depth support
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        arView.session.run(configuration)
        
        stateManager.sceneData.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            updateScene(for: arView)
        }
        
        // Initialize sceneData on stateManager
        stateManager.initializSceneData(arView: arView)
        
        return arView
    }
    
    func triggerHapticFeedback() {
        generator.prepare()
        generator.impactOccurred()
    }
}

// TODO: I found removing gestureRecognizers from the arView mandatory also when removing an object from the scene because otherwise it isn't released from memory and thus it increases the app's footprint.
