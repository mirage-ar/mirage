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
    @StateObject var viewModel: ARViewModel
    
    @State var miraAdded: Bool = false
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = viewModel.arView
        arView.automaticallyConfigureSession = false
        
        setupARViewConfiguration(arView)
        
        // Setup scene observer
        viewModel.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            updateScene(for: arView)
        }
        
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        setupARViewConfiguration(arView)
    }
    
    private func updateScene(for arView: ARView) {}
    
    func setupARViewConfiguration(_ arView: ARView) {
        let currentConfiguration = arView.session.configuration
            
        if !(currentConfiguration is ARWorldTrackingConfiguration) {
            print("UPDATE: AR configuration changed to WORLD TRACKING")
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
                
            // Check for LiDAR support
            if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
//                configuration.sceneReconstruction = .mesh
//                arView.environment.sceneUnderstanding.options.insert(.occlusion)
//                arView.debugOptions.insert(.showSceneUnderstanding)
            }
                
            // Check for person segmentation with depth support
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                configuration.frameSemantics.insert(.personSegmentationWithDepth)
            }
                
            arView.session.run(configuration)
            
            viewModel.addMiraToScene()
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewRepresentable

        init(_ parent: ARViewRepresentable) {
            self.parent = parent
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            print("ADDED")
            for anchor in anchors {
                print(anchor.name)
            }
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {}
    }
}
