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
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ARViewRepresentable(viewModel: viewModel).ignoresSafeArea()
                    .onTapGesture { gesture in
                        if let entity = viewModel.arView.entity(at: gesture) {
                            // user tapped on an entity
                            viewModel.selectedMira = viewModel.findMiraByEntity(name: entity.name)
                            viewModel.sceneData.updateSelectedEntity(entity)
                        } else if viewModel.sceneData.selectedEntity != nil || viewModel.selectedMira != nil {
                            // return user to create screen
                            viewModel.selectedMira = nil
                            viewModel.sceneData.selectedEntity = nil
                            viewModel.miraCreateMenuType = .DEFAULT
                            viewModel.revertShape()
                            
                            // User is creating a Mira
                        } else {
                            // Get camera information
                            let cameraPosition = viewModel.arView.cameraTransform.translation
                            let cameraOrientation = viewModel.arView.cameraTransform.rotation
                            let forwardVector = simd_float3(0, 0, -0.4)

                            // Handle media
                            if let image = media?.image {
                                guard let (anchor, mediaEntity) = viewModel.createImageEntity(image, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector), let anchorEntity = anchor else {
                                    // TODO: error handling
                                    print("ERROR: Could not create Entity")
                                    return
                                }
                                
                                triggerHapticFeedback()
                                viewModel.arView.scene.addAnchor(anchorEntity)
                                viewModel.addMediaEntityToMira(mediaEntity)
                                
                            } else if let videoURL = media?.videoURL {
                                let (anchor, mediaEntity) = viewModel.createVideoEntity(videoURL, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector)
                                guard let anchorEntity = anchor else {
                                    // TODO: error handling
                                    return
                                }
                                
                                // TODO: clean up
                                triggerHapticFeedback()
                                viewModel.arView.scene.addAnchor(anchorEntity)
                                viewModel.addMediaEntityToMira(mediaEntity)
                            }
                        }
                    }
                VStack {
                    Spacer()
                    ARViewOverlayMenu(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $viewModel.sceneData.showMediaPicker) {
                PhotosPickerView(media: $media, isPresented: $viewModel.sceneData.showMediaPicker)
            }
        }
    }
    
    func triggerHapticFeedback() {
        generator.prepare()
        generator.impactOccurred()
    }
}
