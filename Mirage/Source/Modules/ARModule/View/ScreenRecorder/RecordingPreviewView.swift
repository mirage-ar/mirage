//
//  RecordingPreviewView.swift
//  Mirage
//
//  Created by Saad on 22/08/2023.
//

import SwiftUI
import ReplayKit

struct RecordingPreviewView: UIViewControllerRepresentable {
    let rpPreviewViewController: RPPreviewViewController
    @Binding var isShow: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> RPPreviewViewController {
        rpPreviewViewController.previewControllerDelegate = context.coordinator
        rpPreviewViewController.modalPresentationStyle = .fullScreen
        
        return rpPreviewViewController
    }
    
    func updateUIViewController(_ uiViewController: RPPreviewViewController, context: Context) { }
    
    class Coordinator: NSObject, RPPreviewViewControllerDelegate {
        var parent: RecordingPreviewView
        
        init(_ parent: RecordingPreviewView) {
            self.parent = parent
        }
        
        func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
            withAnimation {
                parent.isShow = false
            }
        }
    }
}
