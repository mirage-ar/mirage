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
                if let resizedImage = resizeImage(image: uiImage, toWidth: 300) {
                    parent.media = Media(type: .image(resizedImage), image: resizedImage, videoURL: nil)
                }
            } else if let videoURL = info[.mediaURL] as? URL {
                parent.media = Media(type: .video(videoURL), image: nil, videoURL: videoURL)
            }
            
            picker.dismiss(animated: true)
        }
    }
}

func resizeImage(image: UIImage, toWidth width: CGFloat) -> UIImage? {
    let imageSize = image.size
    let widthRatio = width / imageSize.width

    let newSize = CGSize(width: imageSize.width * widthRatio, height: imageSize.height * widthRatio)
    let newRect = CGRect(origin: .zero, size: newSize)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: newRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
}
