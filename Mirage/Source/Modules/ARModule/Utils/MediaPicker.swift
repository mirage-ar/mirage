//
//  Extensions.swift
//  Miras
//
//  Created by fiigmnt on 2/13/23.
//

import SwiftUI
import UniformTypeIdentifiers

enum MediaType {
    case image(UIImage)
    case video(URL)
}

public struct Media {
    let type: MediaType
    let image: UIImage?
    let videoURL: URL?
}

public struct MediaPickerView: UIViewControllerRepresentable {
    @Binding var showMediaPicker: Bool
    private let onImagePicked: (Media) -> Void

    public init(showMediaPicker: Binding<Bool>, onImagePicked: @escaping (Media) -> Void) {
        self._showMediaPicker = showMediaPicker
        self.onImagePicked = onImagePicked
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.showMediaPicker = false },
            onImagePicked: self.onImagePicked
        )
    }

    public final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let onDismiss: () -> Void
        private let onImagePicked: (Media) -> Void

        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (Media) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
//                if let resizedImage = resizeImage(image: uiImage, toWidth: 300) {
                self.onImagePicked(Media(type: .image(uiImage), image: uiImage, videoURL: nil))
//                }
            } else if let videoURL = info[.mediaURL] as? URL {
                self.onImagePicked(Media(type: .video(videoURL), image: nil, videoURL: videoURL))
            }

            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
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
