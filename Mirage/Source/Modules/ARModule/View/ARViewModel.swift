//
//  ARCameraViewModel.swift
//  Mirage
//
//  Created by fiigmnt on 6/7/23.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

enum MiraCreateMenuType {
    case DEFAULT
    case MODIFY
    case SHAPE
}

enum ARViewMode {
    case EXPLORE
    case CREATE
}

final class ARViewModel: ObservableObject {
    // AR related data
    @Published var arView: ARViewController = ARViewController(frame: .zero)
    @Published var arViewMode: ARViewMode = .EXPLORE
    
    @Published var selectedMira: Mira? = nil
    
    // Handle updates to scene data properties
    @Published var sceneData: ARSceneData = .init() {
        didSet {
            sceneDataCancellable = sceneData.objectWillChange.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        }
    }
        
    private var sceneDataCancellable: AnyCancellable?
        
    init() {
        sceneDataCancellable = sceneData.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
        
    @Published var arViewLocalized: Bool = false
    @Published var showMediaPicker: Bool = false
    
    @Published var miraCreateMenuType: MiraCreateMenuType = .DEFAULT
    @Published var modiferAmount: Float = 1.0
    
    @Published var currentMira: Mira?
    
    func initializeMira(_ mediaEntity: MediaEntity) {
        print("UPDATE: Initialize Mira")
        // TODO: update to current creator
        if let location = LocationManager.shared.location {
            let creator = User(id: UserDefaultsStorage().getString(for: .userId) ?? UUID().uuidString, profileImage: "", profileImageDesaturated: "", userName: "test", profileDescription: "")
            
            
//            let arMedia = ARMedia(id: UUID().uuidString, contentType: mediaEntity.contentType., assetUrl: , shape: <#T##ShapeType#>, modifier: <#T##ModifierType#>, position: <#T##String#>)
            let mira = Mira(id: UUID().uuidString, location: location, isViewed: false, isFriend: false, hasCollected: false, arMedia: [], creator: creator, collectors: nil)
            currentMira = mira
        } else {
            print("ERROR: no access to location")
            
            // TODO: remove default location
            let location = CLLocationCoordinate2D(latitude: 72.21, longitude: -40.2)
            let creator = User(id: UserDefaultsStorage().getString(for: .userId) ?? UUID().uuidString, profileImage: "", profileImageDesaturated: "", userName: "test", profileDescription: "")
            let mira = Mira(id: UUID().uuidString, location: location, isViewed: false, isFriend: false, hasCollected: false, arMedia: [], creator: creator, collectors: nil)
            currentMira = mira
        }
    }
        
    private var workItem: DispatchWorkItem?
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
        
    func initializSceneData(arView: ARView) {
        sceneData.setupGestureHandler(arView: arView)
    }
    
    func removeAllMedia() {
        for mediaEntity in sceneData.mediaEntities {
            removeEntity(mediaEntity)
        }
    }
    
    // Create ARMedia Entities
    func createImageEntity(_ image: UIImage, cameraPosition: XYZ, cameraOrientation: simd_quatf, forwardVector: simd_float3) -> (AnchorEntity?, MediaEntity)? {
        do {
            let imageOrientation = image.imageOrientation
            
            let rotatedImage = image.rotated(to: imageOrientation)
            let transform: SIMD3<Float> = cameraPosition + cameraOrientation.act(forwardVector)
            let anchor = AnchorEntity(world: transform)
            
            // Use the rotated image to create the material and model entity
            var material = UnlitMaterial()
            let texture = try TextureResource.generate(from: rotatedImage.cgImage!, options: TextureResource.CreateOptions(semantic: nil))
            
            material.color = .init(tint: .white.withAlphaComponent(0.999),
                                   texture: .init(texture))
            
            let size: CGSize = .init(width: rotatedImage.size.width, height: rotatedImage.size.height)
            let aspectRatio = Float(size.width / size.height)
            let width: Float = 0.02 * 9 // default width value
            let height: Float = width / aspectRatio
            
            let mesh: MeshResource = .generateBox(width: width, height: height, depth: 0.0)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.generateCollisionShapes(recursive: true)
            arView.installGestures([.scale, .rotation], for: entity)
            
            let translationGesture = arView.installGestures(.translation, for: entity).first
            
            entity.look(at: cameraPosition, from: entity.position, upVector: [0, 0, 1], relativeTo: nil)
            entity.orientation = cameraOrientation
            
            let mediaEntity = MediaEntity(entity: entity, height: height, width: width, shape: .PLANE, modifier: .NONE, transform: transform, contentType: .PHOTO, translationGesture: translationGesture, texture: texture)
            sceneData.updateSelectedEntity(mediaEntity)
            
            entity.name = String(anchor.id)
            anchor.addChild(entity)
            return (anchor, mediaEntity)
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    func createVideoEntity(_ videoURL: URL, cameraPosition: XYZ, cameraOrientation: simd_quatf, forwardVector: simd_float3) -> (AnchorEntity?, MediaEntity) {
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let material = VideoMaterial(avPlayer: player)
        
        // quick fix to loop the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        player.volume = 0.1
        player.play()
        
        let transform: SIMD3<Float> = cameraPosition + cameraOrientation.act(forwardVector)
        let anchor = AnchorEntity(world: transform)
        
        // Extract video orientation metadata
        let videoTrack = asset.tracks(withMediaType: .video).first
        let videoTransform = videoTrack?.preferredTransform
        let videoAngleInDegrees = atan2(videoTransform!.b, videoTransform!.a) * 180 / .pi
        
        let videoSize = videoTrack?.naturalSize ?? .zero
        let aspectRatio = Float(videoSize.width / videoSize.height)
        let width: Float = 0.02 * 9 // default width value
        let height: Float = width / aspectRatio
        
        let mesh: MeshResource = .generateBox(width: width, height: height, depth: 0.002)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.scale, .rotation], for: entity)
        
        let translationGesture = arView.installGestures(.translation, for: entity).first
        
        // Store the AVPlayer instance in the dictionary using entity's identifier as the key
        sceneData.avPlayers[entity.id] = player
        
        entity.look(at: cameraPosition, from: entity.position, upVector: [0, 0, 1], relativeTo: nil)
        
        // Apply rotation based on video orientation metadata
        switch videoAngleInDegrees {
        case 90:
            entity.orientation = cameraOrientation * simd_quatf(angle: -.pi / 2, axis: [0, 0, 1])
        case -90:
            entity.orientation = cameraOrientation * simd_quatf(angle: .pi / 2, axis: [0, 0, 1])
        case 180:
            entity.orientation = cameraOrientation * simd_quatf(angle: .pi, axis: [0, 0, 1])
        default:
            entity.orientation = cameraOrientation
        }
        
        let mediaEntity = MediaEntity(entity: entity, height: height, width: width, shape: .PLANE, modifier: .NONE, transform: transform, contentType: .VIDEO, translationGesture: translationGesture)
        sceneData.updateSelectedEntity(mediaEntity)
        
        entity.name = String(anchor.id)
        anchor.addChild(entity)
        return (anchor, mediaEntity)
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
            
        if modifier == .SPIN {
            guard let modelEntity = sceneData.selectedEntity?.entity as? ModelEntity else { return }
            rotateModel(modelEntity)
        }
    }
        
    // TODO: create a more sustainable method for rotation
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
            
        if modifier == .SPIN {
            guard let modelEntity = sceneData.selectedEntity?.entity as? ModelEntity else { return }
                
            // Cancel DispatchQueue
            workItem?.cancel()
        }
    }
        
    func removeEntity(_ entity: Entity) {
        // Stop the AVPlayer if it exists in the avPlayers dictionary
        if let player = sceneData.avPlayers[entity.id] {
            player.pause()
            sceneData.avPlayers.removeValue(forKey: entity.id)
        }
            
        // remove entity from array
        if let entityIndex = sceneData.mediaEntities.firstIndex(where: { $0.entity.id == entity.id }) {
            sceneData.mediaEntities.remove(at: entityIndex)
        }
            
        entity.removeFromParent()
        sceneData.selectedEntity = nil
    }
    
    func removeEntity(_ mediaEntity: MediaEntity) {
        removeEntity(mediaEntity.entity)
    }
    
    func triggerHapticFeedback() {
        generator.prepare()
        generator.impactOccurred()
    }
    
    func addMediaEntityToMira(_ mediaEntity: MediaEntity) {
        print("UPDATE: adding mediaEntity to current Mira")
    }
    
    func lockMira() {
        
    }
}
