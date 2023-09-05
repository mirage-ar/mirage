//
//  ARCameraViewModel.swift
//  Mirage
//
//  Created by fiigmnt on 6/7/23.
//

import ARKit
import Combine
import RealityKit
import SwiftUI

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
    @Published var arView: ARViewController = .init(frame: .zero)
    @Published var arViewMode: ARViewMode = .EXPLORE
    
    @Published var selectedMira: Mira? = nil
    @Published var miraPosted: Bool = false
    
    // TODO: cleanup
    let arApolloRepository: ARApolloRepository = AppConfiguration.shared.apollo
    
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
    
    private var currentARMedia: [ARMedia] = []
    
    @Published var viewingMiras: [Mira]?
    
    func initializeMira() {
        // Get current location
        guard let location = LocationManager.shared.location else {
            print("ERROR: Initialize Mira failed - no location available.")
            return
        }
        
        guard let elevation = LocationManager.shared.elevation else {
            print("ERROR: could not get elevation")
            return
        }
        
        guard let userId = UUID(uuidString: UserDefaultsStorage().getString(for: .userId) ?? "") else {
            print("ERROR: Initialize Mira failed - no user id available.")
            return
        }
        
        // TODO: use stored User
        guard let creator = UserDefaultsStorage().getUser() else {
            print("ERROR: Could not access current user")
            return
        }
        
        // Create new Mira with an empty array of ARMedia
        let mira = Mira(id: UUID(), creator: creator, location: location, elevation: elevation, arMedia: [], collectors: nil)
        currentMira = mira
    }
    
    func addMediaEntityToMira(_ mediaEntity: MediaEntity) {
        // ensure that there is a Mira to add media to
        guard let currentMira = currentMira else {
            print("ERROR: No Mira to add media to.")
            return
        }
        
        if mediaEntity.contentType == .video, let videoUrl = mediaEntity.videoUrl {
            DownloadManager.shared.upload(filePath: videoUrl.absoluteString) { url in
                guard let url = url else {
                    print("ERROR: Failed to upload video.")
                    return
                }
                
                let arMedia = ARMedia(id: mediaEntity.id, contentType: mediaEntity.contentType, assetUrl: url, shape: mediaEntity.shape, modifier: mediaEntity.modifier, transform: mediaEntity.transform)
            
                // Update UI on the main thread
                self.currentARMedia.append(arMedia)
            }
        }
        
        if let image = mediaEntity.image {
            DownloadManager.shared.upload(image: image) { url in
                guard let url = url else {
                    print("ERROR: Failed to upload image.")
                    return
                }
                let arMedia = ARMedia(id: mediaEntity.id, contentType: mediaEntity.contentType, assetUrl: url, shape: mediaEntity.shape, modifier: mediaEntity.modifier, transform: mediaEntity.transform)
            
                self.currentARMedia.append(arMedia)
            }
        }
    }
    
    func removeMediaEntityFromMira(id: UUID) {
        currentARMedia.removeAll(where: { $0.id == id })
    }
    
    private var workItem: DispatchWorkItem?
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    func initializSceneData(arView: ARView) {
        sceneData.setupGestureHandler(arView: arView)
    }
    
    func closeARSession() {
        arView.session.pause()
        
        for (id, player) in sceneData.avPlayers {
            player.pause()
            sceneData.avPlayers[id] = nil
        }
        
        for transformCancelable in sceneData.transformCancellables {
            transformCancelable.cancel()
        }
        
        sceneData.avPlayers = [:]
        sceneDataCancellable?.cancel()
        sceneData.sceneObserver?.cancel()
    }
    
    func removeAllMedia() {
        for mediaEntity in sceneData.mediaEntities {
            removeEntity(mediaEntity)
        }
    }
    
    func removeSelectedEntity() {
        sceneData.selectedEntity = nil
        sceneData.selectedShape = .plane
        sceneData.selectedModifier = .none
    }
    
    func findMiraByEntity(name: String) -> Mira? {
        return viewingMiras?.first(where: { $0.arMedia.contains(where: { $0.id.uuidString == name }) })
    }
    
    func updateSelectedMira(_ mira: Mira) {
        selectedMira = mira
    }
    
    // Create ARMedia Entities
    func createImageEntity(_ image: UIImage, cameraPosition: XYZ, cameraOrientation: simd_quatf, forwardVector: simd_float3) -> (AnchorEntity?, MediaEntity)? {
        do {
            let imageOrientation = image.imageOrientation
            
            let rotatedImage = image.rotated(to: imageOrientation)
            let position: SIMD3<Float> = cameraPosition + cameraOrientation.act(forwardVector)
            let anchor = AnchorEntity(world: position)
            
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
            let gestures = arView.installGestures([.scale, .rotation, .translation], for: entity)
            
            entity.look(at: cameraPosition, from: entity.position, upVector: [0, 0, 1], relativeTo: nil)
            entity.orientation = cameraOrientation
            
            let transform = entity.transform.matrix
            
            let mediaEntity = MediaEntity(entity: entity, height: height, width: width, shape: .plane, modifier: .none, transform: transform, contentType: .photo, image: image, gestures: gestures, texture: texture)
            sceneData.updateSelectedEntity(mediaEntity)
            
            entity.name = String(anchor.id)
            anchor.addChild(entity)
            return (anchor, mediaEntity)
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    func createVideoEntity(_ videoUrl: URL, cameraPosition: XYZ, cameraOrientation: simd_quatf, forwardVector: simd_float3) -> (AnchorEntity?, MediaEntity) {
        let asset = AVURLAsset(url: videoUrl)
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
        
        let position: SIMD3<Float> = cameraPosition + cameraOrientation.act(forwardVector)
        let anchor = AnchorEntity(world: position)
        
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
        let gestures = arView.installGestures([.scale, .rotation, .translation], for: entity)
        
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
        
        let transform = entity.transform.matrix
        
        let mediaEntity = MediaEntity(entity: entity, height: height, width: width, shape: .plane, modifier: .none, transform: transform, contentType: .video, videoUrl: videoUrl, gestures: gestures)
        
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
            case .plane:
                changeShape(to: .generateBox(width: selectedEntity.width, height: selectedEntity.height, depth: 0.002))
            case .cube:
                changeShape(to: .generateBox(width: selectedEntity.width, height: selectedEntity.height, depth: selectedEntity.width))
            case .sphere:
                changeShape(to: .generateSphere(radius: selectedEntity.width / 1.5))
            }
            
            // TODO: update shape for media entity
            sceneData.updateSelectedEntity(selectedEntity)
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
        
        // TODO: move to function - not working
        if let selectedEntity = sceneData.selectedEntity {
            // update media entity
            if let selectedIndex = sceneData.mediaEntities.firstIndex(where: { $0.entity.id == selectedEntity.entity.id }) {
                sceneData.mediaEntities[selectedIndex].modifier = modifier
            }
        }
        
        if modifier == .rotate {
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
        
        if modifier == .rotate {
            guard let modelEntity = sceneData.selectedEntity?.entity as? ModelEntity else { return }
            
            // Cancel DispatchQueue
            workItem?.cancel()
        }
    }
    
    func removeEntity(_ entity: Entity) {
        // TODO: remove entity from mira as well
        
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
        removeSelectedEntity()
    }
    
    func removeEntity(_ mediaEntity: MediaEntity) {
        removeEntity(mediaEntity.entity)
    }
    
    func triggerHapticFeedback() {
        generator.prepare()
        generator.impactOccurred()
    }
    
    func lockMira() {
        guard var mira = currentMira else {
            print("ERROR: mira not available")
            return
        }
        
        // remove gestures on mira
        for mediaEntity in sceneData.mediaEntities {
            mediaEntity.gestures.forEach { $0.isEnabled = false }
        }
        
        var arMediaArray: [ARMedia] = []
        
        // TODO: clean up scene data, and currentArMedia
        for entity in sceneData.mediaEntities {
            let media = currentARMedia.first(where: { $0.id == entity.id })
            
            // create new ARMedia entity based on sceneData info
            if let media = media {
                let arMedia = ARMedia(id: entity.id, contentType: entity.contentType, assetUrl: media.assetUrl, shape: entity.shape, modifier: entity.modifier, transform: entity.entity.transform.matrix)
                
                arMediaArray.append(arMedia)
            }
        }
        
        mira.arMedia = arMediaArray

        arApolloRepository.addMira(mira)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel(receiveOutput: { mira in
                guard let mira = mira else { return }
            }, receiveError: { error in
                print("Error: \(error)")
            })
    }
    
    func addMiraToScene() {
        arApolloRepository.getARMiras(location: LocationManager.shared.location!, zoomLevel: 30)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel(receiveOutput: { miras in
                guard let miras = miras else { return }
                self.viewingMiras = miras
                self.initializeAllViewingMiras(miras)
            }, receiveError: { error in
                print("Error: \(error)")
                                
            })
    }

    func initializeAllViewingMiras(_ miras: [Mira]) {
        debugPrint("ADDING MIRAS")
        for item in miras {
            let location = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)
            let geoAnchor = ARGeoAnchor(name: item.id.uuidString, coordinate: location, altitude: item.elevation ?? nil)
                
            arView.session.add(anchor: geoAnchor)
                
            let cameraTransform = arView.cameraTransform
                
            for arMedia in item.arMedia {
                DownloadManager.shared.download(url: arMedia.assetUrl) { _ in
                } completion: { filePath in
                    print("Complete 4 " + (filePath ?? ""))

                    if arMedia.contentType == .photo {
                        if let urlString = filePath {
                            let url = URL(string: urlString)
                            do {
                                let data = try Data(contentsOf: url!)
                                guard let image = UIImage(data: data) else {
                                    print("ERROR: Could not create image")
                                    return
                                }
                                DispatchQueue.main.async {
                                    // update the transform based on our camera:
                                        
                                    if let anchorEntity = self.createGeoImageEntity(id: arMedia.id, image: image, shape: arMedia.shape, modifier: arMedia.modifier, geoAnchor: geoAnchor, transform: arMedia.transform) {
                                        self.arView.scene.anchors.append(anchorEntity)
                                    } else {
                                        print("ERROR: could not create geo entity")
                                    }
                                }
                                        
                            } catch {
                                print("Unable to load data: \(error)")
                            }
                        }
                    } else if arMedia.contentType == .video {
                        guard let video = URL(string: filePath!) else {
                            print("ERROR: could not create video")
                            return
                        }
                        DispatchQueue.main.async {
                            if let anchorEntity = self.createGeoVideoEntity(id: arMedia.id, video: video, shape: arMedia.shape, modifier: arMedia.modifier, geoAnchor: geoAnchor, transform: arMedia.transform) {
                                self.arView.scene.anchors.append(anchorEntity)
                            } else {
                                print("ERROR: could not create geo entity")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // TODO: not functioning properly
    func collectMira(id: UUID) {
        arApolloRepository.collectMira(id: id)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel(receiveOutput: { _ in
            }, receiveError: { error in
                print("Error: \(error)")
            })
    }
    
    func createGeoImageEntity(id: UUID, image: UIImage, shape: ShapeType, modifier: ModifierType, geoAnchor: ARGeoAnchor, transform: simd_float4x4) -> AnchorEntity? {
        do {
            let imageOrientation = image.imageOrientation
            let rotatedImage = image.rotated(to: imageOrientation)
            
            guard let cgImage = rotatedImage.cgImage else {
                // Handle error here
                print("Error: Couldn't get CGImage from rotated image.")
                return nil
            }
            
            // Use the rotated image to create the material and model entity
            let texture = try TextureResource.generate(from: cgImage, options: TextureResource.CreateOptions(semantic: nil))
            
            var material = UnlitMaterial()
            material.color = .init(tint: .white.withAlphaComponent(0.999),
                                   texture: .init(texture))

            // TODO: update to use shape and modifer from arMedia
            let size: CGSize = .init(width: rotatedImage.size.width, height: rotatedImage.size.height)
            let aspectRatio = Float(size.width / size.height)
            let width: Float = 0.02 * 9 // default width value
            let height: Float = width / aspectRatio

            var mesh: MeshResource = .generateBox(width: width, height: height, depth: 0.002)
            
            // TODO: cleanup shape logic
            if shape == .cube {
                mesh = .generateBox(width: width, height: height, depth: width)
            } else if shape == .sphere {
                mesh = .generateSphere(radius: width / 1.5)
            }
        
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.generateCollisionShapes(recursive: true)

            entity.transform.matrix = transform
            entity.name = id.uuidString
            
            if modifier == .rotate {
                rotateModel(entity)
            }

            let anchorEntity = AnchorEntity(anchor: geoAnchor)
            anchorEntity.name = id.uuidString
            anchorEntity.addChild(entity)

            return anchorEntity

        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    func createGeoVideoEntity(id: UUID, video: URL, shape: ShapeType, modifier: ModifierType, geoAnchor: ARGeoAnchor, transform _: simd_float4x4) -> AnchorEntity? {
        let asset = AVURLAsset(url: video)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let material = VideoMaterial(avPlayer: player)
        
        // quick fix to loop the video
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
//            player.seek(to: CMTime.zero)
//            player.play()
//        }
        player.volume = 0.1
        player.play()
        
        // Extract video orientation metadata
        let videoTrack = asset.tracks(withMediaType: .video).first
        let videoTransform = videoTrack?.preferredTransform
        let videoAngleInDegrees = atan2(videoTransform!.b, videoTransform!.a) * 180 / .pi
        
        let videoSize = videoTrack?.naturalSize ?? .zero
        let aspectRatio = Float(videoSize.width / videoSize.height)
        let width: Float = 0.02 * 9 // default width value
        let height: Float = width / aspectRatio
        
        var mesh: MeshResource = .generateBox(width: width, height: height, depth: 0.002)
        
        // TODO: cleanup shape logic
        if shape == .cube {
            mesh = .generateBox(width: width, height: height, depth: width)
        } else if shape == .sphere {
            mesh = .generateSphere(radius: width / 1.5)
        }
        
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.generateCollisionShapes(recursive: true)
        
        // Store the AVPlayer instance in the dictionary using entity's identifier as the key
        sceneData.avPlayers[entity.id] = player
        
        let transform = entity.transform.matrix
           
        entity.transform.matrix = transform
        entity.name = id.uuidString
        
        if modifier == .rotate {
            rotateModel(entity)
        }

        let anchorEntity = AnchorEntity(anchor: geoAnchor)
        anchorEntity.name = id.uuidString
        anchorEntity.addChild(entity)

        return anchorEntity
    }
}
