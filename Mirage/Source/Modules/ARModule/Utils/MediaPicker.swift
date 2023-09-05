//
//  Extensions.swift
//  Miras
//
//  Created by fiigmnt on 2/13/23.
//

import MobileCoreServices
import SwiftUI

import Photos

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

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MediaPicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: MediaPicker

        init(_ parent: MediaPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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

class PhotosViewModel: ObservableObject {
    @Published var photos: [PHAsset] = []

    func fetchPhotosAndVideos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)

        let result = PHAsset.fetchAssets(with: fetchOptions)
        photos = result.objects(at: IndexSet(0..<result.count))
    }
}

struct PhotosPickerView: View {
    @StateObject var viewModel = PhotosViewModel()
    @Binding var media: Media?
    @Binding var isPresented: Bool

    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.photos, id: \.self) { asset in
                    Button(action: {
                        if asset.mediaType == .image {
                            let selectedImage = self.loadThumbnail(for: asset)
                            media = Media(type: .image(selectedImage), image: selectedImage, videoURL: nil)
                        } else if asset.mediaType == .video {
                            loadVideoURL(for: asset) { videoURL in
                                media = Media(type: .video(videoURL!), image: nil, videoURL: videoURL)
                            }
                        }
                        isPresented = false
                    }) {
                        // Display the asset thumbnail
                        Image(uiImage: self.loadThumbnail(for: asset))
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
                            .clipped()
                        // If the asset is a video, you might want to overlay a small video icon to indicate it's not a photo
//                        if asset.mediaType == .video {
//                            Image(systemName: "video.fill") // using SF Symbols for a video icon
//                                .foregroundColor(.white)
//                                .background(Color.black.opacity(0.6))
//                                .clipShape(Circle())
//                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPhotosAndVideos()
        }
    }

    func loadThumbnail(for asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: option, resultHandler: {(result, _) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func loadVideoURL(for asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .original
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (asset, _, _) in
            if let asset = asset as? AVURLAsset {
                completion(asset.url)
            } else {
                completion(nil)
            }
        }
    }
}
