//
//  ARSceneData.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 4/15/23.
//

import RealityKit
import Combine
import AVKit

class EntityLongPressGestureRecognizer: UILongPressGestureRecognizer {
    weak var arEntity: Entity?
    var initialTouchLocation: CGPoint?
}

enum MediaEntityType {
    case PHOTO
    case VIDEO
}

struct MediaEntity {
    var entity: Entity
    var height: Float
    var width: Float
//    var type: MediaEntityType
    var shape: ShapeType
    var modifier: ModifierType
    
    var withinBounds: Bool = true
    var translationGesture: EntityGestureRecognizer?
    
    var texture: TextureResource?
}

class ARSceneData: ObservableObject {
    @Published var transformCancellables: [AnyCancellable]
    @Published var mediaEntities: [MediaEntity]
    @Published var selectedEntity: MediaEntity?
    @Published var showMediaPicker: Bool = false
    @Published var avPlayers: [UInt64: AVPlayer] = [:]
    
    @Published var selectedShape: ShapeType = .PLANE
    @Published var previousShape: ShapeType = .PLANE
    
    @Published var selectedModifier: ModifierType = .NONE
    @Published var previousModifier: ModifierType = .NONE
    
    private var gestureHandler: GestureHandler?
    
    var sceneObserver: Cancellable?
    
    init() {
        self.transformCancellables = []
        self.mediaEntities = []
    }
    
    func updateShowMediaPicker(_ value: Bool) {
        showMediaPicker = value
    }
    
    func setupGestureHandler(arView: ARView) {
        
        // Initialize the GestureHandler
        self.gestureHandler = GestureHandler(arView: arView, sceneData: self, updateShowMediaPicker: self.updateShowMediaPicker)

        // Add the long press gesture recognizer
        let elevationGesture = EntityLongPressGestureRecognizer(target: self.gestureHandler, action: #selector(GestureHandler.handleLongPressGesture))
        arView.addGestureRecognizer(elevationGesture)
        
    }
    
    // TODO: reduce redundancy
    func updateSelectedEntity(_ mediaEntity: MediaEntity) {
        if let selectedIndex = mediaEntities.firstIndex(where: { $0.entity.id == mediaEntity.entity.id }) {
            selectedShape = mediaEntity.shape
            previousShape = selectedShape
            
            selectedModifier = mediaEntity.modifier
            previousModifier = selectedModifier
            
            mediaEntities.remove(at: selectedIndex)
            mediaEntities.append(mediaEntity)
        } else {
            selectedEntity = mediaEntity
            mediaEntities.append(mediaEntity)
        }
    }
    
    func updateSelectedEntity(_ entity: Entity) {
        if let selectedIndex = mediaEntities.firstIndex(where: { $0.entity.id == entity.id }) {
            selectedEntity = mediaEntities[selectedIndex]
            
            if let selectedEntity = selectedEntity {
                
                selectedShape = selectedEntity.shape
                previousShape = selectedShape
                
                selectedModifier = selectedEntity.modifier
                previousModifier = selectedModifier
                
                mediaEntities.remove(at: selectedIndex)
                mediaEntities.append(selectedEntity)
            }
        }
    }
    
    func retrieveMediaEntity(_ entity: Entity) -> MediaEntity? {
        if let selectedIndex = mediaEntities.firstIndex(where: { $0.entity.id == entity.id }) {
             return mediaEntities[selectedIndex]
        }
        
        print("ERROR: could not retieve MediaEntity from Entity")
        return nil
    }
}
