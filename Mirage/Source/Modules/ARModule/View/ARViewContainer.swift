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

struct ARViewContainer: View {
    @StateObject var viewModel: ARViewModel
    
    @State var media: Media?
    @State private var showBottomNavigation: Bool = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ARViewRepresentable(viewModel: viewModel).ignoresSafeArea()
                    .onTapGesture { gesture in
                        if let entity = viewModel.arView.entity(at: gesture) {
                            // user tapped on an entity
                            if viewModel.arViewMode == .EXPLORE {
                                // find mira by entity
                                viewModel.selectedMira = viewModel.findMiraByEntity(name: entity.name)
                                
                            } else {
                                viewModel.sceneData.updateSelectedEntity(entity)
                            }
                        } else if viewModel.sceneData.selectedEntity != nil {
                            // return user to create screen
                            if viewModel.miraCreateMenuType == .DEFAULT {
                                viewModel.sceneData.selectedEntity = nil
                            }
                            
                            // user is creating mira
                        } else {
                            // Get camera information
                            let cameraPosition = viewModel.arView.cameraTransform.translation
                            let cameraOrientation = viewModel.arView.cameraTransform.rotation
                            let forwardVector = simd_float3(0, 0, -0.4)

                            // Handle video media
                            if let videoURL = media?.videoURL {
                                let (anchor, mediaEntity) = viewModel.createVideoEntity(videoURL, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector)
                                guard let anchorEntity = anchor else {
                                    // TODO: error handling
                                    return
                                }
                                
                                // TODO: clean up
                                viewModel.triggerHapticFeedback()
                                viewModel.arView.scene.addAnchor(anchorEntity)
                                
                                // Handle Mira if necessary
                                if viewModel.arViewLocalized {
                                    if viewModel.currentMira == nil {
                                        // TODO: clean this up
                                        viewModel.initializeMira()
                                        viewModel.addMediaEntityToMira(mediaEntity)
                                    } else {
                                        viewModel.addMediaEntityToMira(mediaEntity)
                                    }
                                }
                            }
                            // Handle image media
                            else if let image = media?.image {
                                guard let (anchor, mediaEntity) = viewModel.createImageEntity(image, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector), let anchorEntity = anchor else {
                                    // TODO: error handling
                                    return
                                }
                                
                                viewModel.triggerHapticFeedback()
                                viewModel.arView.scene.addAnchor(anchorEntity)
                                
                                // Handle Mira if necessary
//                                if viewModel.arViewLocalized {
                                    if viewModel.currentMira == nil {
                                        viewModel.initializeMira()
                                        viewModel.addMediaEntityToMira(mediaEntity)
                                    } else {
                                        viewModel.addMediaEntityToMira(mediaEntity)
                                    }
//                                }
                            }
                        }
                    }
                VStack {
                    Spacer()
                    ARViewOverlayMenu(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $viewModel.sceneData.showMediaPicker, onDismiss: loadMedia) {
                MediaPicker(media: $media)
            }
        }
    }
    
    func loadMedia() {
        guard let media = media else { return }
        self.media = media
    }
}
