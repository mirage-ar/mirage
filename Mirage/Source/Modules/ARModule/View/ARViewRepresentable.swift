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
    @EnvironmentObject var stateManager: StateManager
    let view: ARView
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    func makeUIView(context: Context) -> ARView {
        return setupARView(view)
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        // if there is a selected object: grey all other objects
        
        // TODO: add object grey for unselected objects
        
        // UPDATE: removing black background on selected
//        if stateManager.sceneData.selectedEntity != nil {
//            arView.environment.background = .cameraFeed(exposureCompensation: -3.0)
//        } else {
//            arView.environment.background = .cameraFeed()
//        }
        
        // show mesh if editing
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            if stateManager.sceneData.selectedEntity != nil {
                arView.debugOptions.insert(.showSceneUnderstanding)
            } else {
                arView.debugOptions.remove(.showSceneUnderstanding)
            }
        }
    }
    
    private func updateScene(for arView: ARView) {
        // Save the original materials and apply the darkening effect to the other entities
        
        // TODO: removing darken unselected entity
//        if let selectedEntity = stateManager.sceneData.selectedEntity {
//
//            if let selectedEntityAnchorId = selectedEntity.entity.anchor?.id {
//
//                if let originalMaterials = stateManager.originalMaterials[selectedEntityAnchorId] {
//                    let entity = selectedEntity.entity
//                    if var modelComponent = entity.components[ModelComponent] as? ModelComponent {
//                        entity.components[ModelComponent]?.materials = originalMaterials
//                    }
//                }
//
//
//                arView.scene.anchors.forEach { anchor in
//                    if anchor.id != selectedEntityAnchorId, let entity = anchor.findEntity(named: "\(anchor.id)") {
//                        if let modelComponent = entity.components[ModelComponent] as? ModelComponent {
//                            if stateManager.originalMaterials[anchor.id] == nil {
//                                stateManager.originalMaterials[anchor.id] = modelComponent.materials
//                            }
//
//                            // TODO: move method to stateManager
//                            guard let mediaEntity = stateManager.sceneData.mediaEntities.first(where: { $0.entity.id == entity.id }) else { return }
//                            guard let texture = mediaEntity.texture else { return }
//
//                            var material = SimpleMaterial()
//                            material.color = .init(tint: .white.withAlphaComponent(0.999),
//                                                   texture: .init(texture))
//                            entity.components[ModelComponent]?.materials = Array(repeating: material, count: modelComponent.materials.count)
//                        }
//                    }
//                }
//            }
//        } else { // No entity selected, restore the original materials
//            arView.scene.anchors.forEach { anchor in
//                if let originalMaterials = stateManager.originalMaterials[anchor.id],
//                   let entity = anchor.findEntity(named: "\(anchor.id)") {
//                    if var modelComponent = entity.components[ModelComponent] as? ModelComponent {
//                        entity.components[ModelComponent]?.materials = originalMaterials
//                    }
//                }
//            }
//            stateManager.originalMaterials.removeAll()
//        }
        
        guard let selectedEntity = stateManager.sceneData.selectedEntity else { return }
        
        if let entity = selectedEntity.entity as? HasCollision {
            // Extract the translation components from both transforms
            let entityPosition = entity.transform.translation
            let cameraPosition = arView.cameraTransform.translation
            
            // Calculate the distance between the two positions
            let distance = simd_distance(entityPosition, cameraPosition)
//            print(distance)
//
//            print("Distance between entity and camera: \(distance)")
//
//            let distanceMeters = Measurement(value: Double(distance), unit: UnitLength.meters)
//
//            let distanceFeet = distanceMeters.converted(to: .feet).value
            
//            print(distanceFeet)
            
//            stateManager.entityDistance = round(Float(distanceFeet) * 10) / 10.0
//            stateManager.entityDistance = Float(distanceFeet)
            
//            print("scale: \(entity.scale.x)")
            
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
                
//                stateManager.sceneData.selectedEntity?.withinBounds = true
                
            } else if distance < multiplier, !selectedEntity.withinBounds {
                // reinstall the translation gesture
//                let translationGesture = arView.installGestures(.translation, for: entity).first

                // update MediaEntity properties
//                stateManager.sceneData.selectedEntity?.translationGesture = translationGesture
                stateManager.sceneData.selectedEntity?.withinBounds = true
            }
        }
        
        // check to see if an entity is selected
//        if let entity = stateManager.sceneData.selectedEntity?.entity {
//            let cameraTransform = arView.cameraTransform
//            let distance = simd_distance(entity.transform.translation, cameraTransform.translation)
//
//            // If distance exceeds the maximum allowed distance, reset the entity's position
//            if distance > 700 {
//                let newPosition = cameraTransform.matrix.columns.3 + cameraTransform.matrix.columns.2 * -700
//                entity.setPosition(SIMD3(newPosition.x, newPosition.y, newPosition.z), relativeTo: nil)
//            }
//        }
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
