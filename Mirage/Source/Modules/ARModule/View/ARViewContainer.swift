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
                            viewModel.sceneData.updateSelectedEntity(entity)
                        } else if viewModel.sceneData.selectedEntity != nil {
                            if viewModel.miraCreateMenuType == .DEFAULT {
                                viewModel.sceneData.selectedEntity = nil
                            }
                        } else {
                            let cameraPosition = viewModel.arView.cameraTransform.translation
                            let cameraOrientation = viewModel.arView.cameraTransform.rotation
                            let forwardVector = simd_float3(0, 0, -0.4)
                            
                            if media?.videoURL != nil {
                                let arMediaAnchor = viewModel.createVideoEntity(media!.videoURL!, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector)
                                // placed element
                                viewModel.triggerHapticFeedback()
                                viewModel.arView.scene.addAnchor(arMediaAnchor.0!)
                                
                                if viewModel.currentMira == nil {
                                    // create Mira
                                    viewModel.initializeMira(arMediaAnchor.1)
                                } else {
                                    viewModel.addMediaEntityToMira(arMediaAnchor.1)
                                }
                            } else if media?.image != nil {
                                guard let (anchor, mediaEntity) = viewModel.createImageEntity(media!.image!, cameraPosition: cameraPosition, cameraOrientation: cameraOrientation, forwardVector: forwardVector) else { return }
                                // placed element
                                viewModel.triggerHapticFeedback()
                                viewModel.arView.scene.addAnchor(anchor!)
                                
                                if viewModel.currentMira == nil {
                                    // create Mira
                                    viewModel.initializeMira(mediaEntity)
                                } else {
                                    viewModel.addMediaEntityToMira(mediaEntity)
                                }
                            }
                        }
                    }
//                    .onLongPressGesture(minimumDuration: 0.05) {
//                        stateManager.sceneData.showMediaPicker = true
//                    }
                
                VStack {
                    Spacer()
                    ARViewOverlayMenu(viewModel: viewModel)
                }
                .padding([.leading, .trailing, .bottom])
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
