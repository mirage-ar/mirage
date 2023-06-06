//
//  ARViewContainer.swift
//  Miras
//
//  Created by fiigmnt on 2/13/23.
//

import ARKit
import AVKit
import RealityKit
import simd
import SwiftUI
import UIKit

struct ARViewCreateContainer: View {
    @EnvironmentObject var stateManager: StateManager
    
    @State var media: Media?
    @State private var showBottomNavigation: Bool = false
    
    let arView = ARView(frame: .zero)
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ARViewCreateRepresentable(view: arView).ignoresSafeArea()
                    .onTapGesture { gesture in
                        if let entity = arView.entity(at: gesture) {
                            // user tapped on an entity
                            stateManager.sceneData.updateSelectedEntity(entity)
                            
                            if stateManager.sceneData.selectedEntity != nil {
                                // there is already a selected entity - if it's a video pause or play the video
                                if let player = stateManager.sceneData.avPlayers[entity.id] {
                                    if player.timeControlStatus == .playing {
                                        player.pause()
                                    } else {
                                        player.play()
                                    }
                                }
                                
                                print("PLAY / PAUSE video")
                            }
                            
                        } else if stateManager.sceneData.selectedEntity != nil {
                            if stateManager.miraCreateMenuType == .DEFAULT {
                                stateManager.sceneData.selectedEntity = nil
                            }
                        } else {
                            let cameraPosition = arView.cameraTransform.translation
                            let cameraOrientation = arView.cameraTransform.rotation
                            let forwardVector = simd_float3(0, 0, -0.4)
                            
                            if media?.videoURL != nil {
                                guard let anchor = createVideoEntity(media!.videoURL!, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector) else { return }
                                // placed element
                                triggerHapticFeedback()
                                arView.scene.addAnchor(anchor)
                            } else if media?.image != nil {
                                guard let anchor = createImageEntity(media!.image!, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector) else { return }
                                // placed element
                                triggerHapticFeedback()
                                arView.scene.addAnchor(anchor)
                            }
                        }
                    }
                    .onLongPressGesture(minimumDuration: 0.05) {
                        stateManager.sceneData.showMediaPicker = true
                    }
                
                if stateManager.sceneData.selectedEntity != nil {
                    VStack {
                        Spacer()
                        OverlayMenu()
                    }
                    .padding([.leading, .trailing, .bottom])
                } else {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                triggerHapticFeedback()
                                stateManager.sceneData.showMediaPicker = true
                            }, label: {
                                Images.buttonMedia.swiftUIImage
                            })
                            .padding(20)
                        }
                    }
                }
            }
            
            .sheet(isPresented: $stateManager.sceneData.showMediaPicker, onDismiss: loadMedia) {
                MediaPicker(media: $media)
            }
        }
    }
    
    func changeShape(to newShape: MeshResource) {
        if let entity = stateManager.sceneData.selectedEntity?.entity as? ModelEntity {
            entity.model?.mesh = newShape
        }
    }
    
    func createImageEntity(_ image: UIImage, cameraPosition: XYZ, cameraOrientation: simd_quatf, forwardVector: simd_float3) -> AnchorEntity? {
        do {
            let imageOrientation = image.imageOrientation
            
            let rotatedImage = image.rotated(to: imageOrientation)
            let anchor = AnchorEntity(world: cameraPosition + cameraOrientation.act(forwardVector))
            
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
            
            let mediaEntity = MediaEntity(entity: entity, height: height, width: width, shape: .PLANE, modifier: .NONE, translationGesture: translationGesture, texture: texture)
            stateManager.sceneData.updateSelectedEntity(mediaEntity)
            
            entity.name = String(anchor.id)
            anchor.addChild(entity)
            return anchor
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    func createVideoEntity(_ videoURL: URL, cameraPosition: XYZ, cameraOrientation: simd_quatf, forwardVector: simd_float3) -> AnchorEntity? {
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
        
        let anchor = AnchorEntity(world: cameraPosition + cameraOrientation.act(forwardVector))
        
        // Extract video orientation metadata
        let videoTrack = asset.tracks(withMediaType: .video).first
        let transform = videoTrack?.preferredTransform
        let videoAngleInDegrees = atan2(transform!.b, transform!.a) * 180 / .pi
        
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
        stateManager.sceneData.avPlayers[entity.id] = player
        
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
        
        let mediaEntity = MediaEntity(entity: entity, height: height, width: width, shape: .PLANE, modifier: .NONE, translationGesture: translationGesture)
        stateManager.sceneData.updateSelectedEntity(mediaEntity)
        
        entity.name = String(anchor.id)
        anchor.addChild(entity)
        return anchor
    }
    
    func loadMedia() {
        guard let media = media else { return }
        self.media = media
    }
    
    func triggerHapticFeedback() {
        generator.prepare()
        generator.impactOccurred()
    }
}
