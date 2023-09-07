//  GestureHandler.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 3/28/23.
//

import Foundation
import RealityKit
import UIKit

class EntityLongPressGestureRecognizer: UILongPressGestureRecognizer {
    weak var arEntity: Entity?
    var initialTouchLocation: CGPoint?
}

class GestureHandler: NSObject {
    private weak var arView: ARView?
    
    
    private var distanceToCamera: Float?
    
    var updateShowMediaPicker: (Bool) -> Void
    var retrieveMediaEntity: (Entity) -> MediaEntity?
    
    var elevationEntity: MediaEntity?
    
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    init(arView: ARView, retrieveMediaEntity: @escaping (Entity) -> MediaEntity?, updateShowMediaPicker: @escaping (Bool) -> Void) {
        self.arView = arView
        self.retrieveMediaEntity = retrieveMediaEntity
        self.updateShowMediaPicker = updateShowMediaPicker
    }

    @objc func handleLongPressGesture(recognizer: EntityLongPressGestureRecognizer) {
        guard let arView = arView else { return }
        
        if recognizer.state == .began {
            generator.impactOccurred()
            // Perform a hit test
            let touchLocation = recognizer.location(in: arView)
            let results = arView.hitTest(touchLocation)
            
            recognizer.initialTouchLocation = touchLocation
            
            if let firstResult = results.first {
//                sceneData?.updateSelectedEntity(firstResult.entity)
                elevationEntity = retrieveMediaEntity(firstResult.entity)
                
                // FIND DISTANCE TO ENTITY HERE
                let cameraPosition = arView.cameraTransform.translation
                let entityPosition = firstResult.entity.transform.translation
                let distance = distanceBetweenVectors(cameraPosition, entityPosition)
                distanceToCamera = distance
                
            } else {
                print("update show media picker")
                updateShowMediaPicker(true)
            }
            
        } else if recognizer.state == .changed {
            guard let arEntity = elevationEntity?.entity, let initialTouchLocation = recognizer.initialTouchLocation else { return }
            
            let currentTouchLocation = recognizer.location(in: arView)
            let deltaY = Float(currentTouchLocation.y - initialTouchLocation.y) * (distanceToCamera ?? 1) * -0.005 // constant for elevation transform
            
            var translation = Transform(matrix: arEntity.transformMatrix(relativeTo: nil))
            translation.translation.y += deltaY
            arEntity.move(to: translation, relativeTo: nil, duration: 0)
            
            recognizer.initialTouchLocation = currentTouchLocation
        } else if recognizer.state == .ended {
            recognizer.arEntity = nil
            recognizer.initialTouchLocation = nil
        }
    }
    
    func distanceBetweenVectors(_ vector1: SIMD3<Float>, _ vector2: SIMD3<Float>) -> Float {
        return length(vector1 - vector2)
    }
}
