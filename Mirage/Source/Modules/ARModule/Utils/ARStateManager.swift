//
//  StateManager.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import Combine
import SwiftUI
import RealityKit
import AVKit
import UIKit

enum ShapeType {
    case PLANE
    case CUBE
    case SPHERE
}

enum ModifierType {
    case NONE
    case TRANSPARENCY
    case SPIN
}

enum MiraCreateMenuType {
    case DEFAULT
    case MODIFY
    case SHAPE
}

final class StateManager: ObservableObject {
    static let shared = StateManager()
    
    // Handle updates to scene data properties
    @Published var sceneData: ARSceneData = ARSceneData() {
        didSet {
            sceneDataCancellable = sceneData.objectWillChange.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        }
    }
    
    private var sceneDataCancellable: AnyCancellable? = nil
    
    init() {
        sceneDataCancellable = sceneData.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    @Published var miraCreateMenuType: MiraCreateMenuType = .DEFAULT
    
    @Published var modiferAmount: Float = 1.0
    
    private var workItem: DispatchWorkItem?
    
    func initializSceneData(arView: ARView) {
        // TODO: create function on scene data reinit on new ARMedia session
        sceneData.setupGestureHandler(arView: arView)
    }
    
    func applyShape(_ shape: ShapeType) {
        sceneData.selectedShape = shape
        sceneData.selectedEntity?.shape = shape
        
        if let selectedEntity = sceneData.selectedEntity {
            switch shape {
            case .PLANE:
                changeShape(to: .generateBox(width: selectedEntity.width, height: selectedEntity.height, depth: 0.002))
            case .CUBE:
                changeShape(to: .generateBox(width: selectedEntity.width, height: selectedEntity.height, depth: selectedEntity.width))
            case .SPHERE:
                changeShape(to: .generateSphere(radius: selectedEntity.width / 1.5))
            }
        }
    }
    
    func revertShape(_ shape: ShapeType) {
        print("REVERT SHAPE: \(shape)")
        applyShape(shape)
    }
    
    func changeShape(to newShape: MeshResource) {
        if let entity = sceneData.selectedEntity?.entity as? ModelEntity {
            entity.model?.mesh = newShape
            entity.collision = nil
            entity.generateCollisionShapes(recursive: true)
        }
    }
    
    func applyModifier(_ modifier: ModifierType) {
        sceneData.selectedModifier = modifier
        print("APPLYING MODIFIER: \(modifier)")
        
        if (modifier == .SPIN) {
            guard let modelEntity = sceneData.selectedEntity?.entity as? ModelEntity else { return }
            rotateModel(modelEntity)
        }
        
    }
    
    func rotateModel(_ modelEntity: ModelEntity) {
        let rotation = simd_quatf(angle: Float.pi, axis: SIMD3<Float>(0, 1, 0))
        let duration = TimeInterval(2) // Duration in seconds

        // Animate the rotation
        let transform = Transform(pitch: 0, yaw: Float.pi, roll: 0)
        modelEntity.move(to: transform, relativeTo: modelEntity, duration: 2.0, timingFunction: .linear)

        let workItem = DispatchWorkItem {
            self.rotateModel(modelEntity)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
        
        // Store the work item in a property or closure for later use
        // This allows you to cancel the work item if needed
         self.workItem = workItem
    }

    func removeModifier(_ modifier: ModifierType) {
        print("REMOVING MODIFIER: \(modifier)")
        
        if (modifier == .SPIN) {
            guard let modelEntity = sceneData.selectedEntity?.entity as? ModelEntity else { return }
            
            // Cancel DispatchQueue
            workItem?.cancel()
        }
    }
    
    func removeEntity(_ entity: Entity) {
        // Stop the AVPlayer if it exists in the avPlayers dictionary
        if let player = sceneData.avPlayers[entity.id] {
            player.pause()
            sceneData.avPlayers.removeValue(forKey: entity.id) // TODO: remove scene data mutations from state manager
        }
        
        // remove entity from array
        if let entityIndex = sceneData.mediaEntities.firstIndex(where: { $0.entity.id == entity.id }) {
            sceneData.mediaEntities.remove(at: entityIndex)
        }
        
        entity.removeFromParent()
        
        // update selected entity
//        if let entity = sceneData.mediaEntities.last?.entity {
//            sceneData.updateSelectedEntity(entity)
//        } else {
            sceneData.selectedEntity = nil
//        }
    }
}
