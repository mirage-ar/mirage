//
//  Extensions.swift
//  Miras
//
//  Created by fiigmnt on 2/13/23.
//

import SwiftUI
import MobileCoreServices

enum MediaType {
    case image(UIImage)
    case video(URL)
}

struct Media {
    let type: MediaType
    let image: UIImage?
    let videoURL: URL?
}

struct MediaPicker: UIViewControllerRepresentable {
    @Binding var media: Media?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MediaPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MediaPicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: MediaPicker
        
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.media = Media(type: .image(uiImage), image: uiImage, videoURL: nil)
            } else if let videoURL = info[.mediaURL] as? URL {
                parent.media = Media(type: .video(videoURL), image: nil, videoURL: videoURL)
            }
            
            picker.dismiss(animated: true)
        }
    }
}


