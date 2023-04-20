//
//  MBMapView.swift
//  Mirage
//
//  Created by Saad on 10/04/2023.
//

import SwiftUI
import MapboxMaps

struct MBMapView: UIViewRepresentable {
    @ObservedObject private var viewModel = MapViewModel()

    func makeUIView(context: Context) -> some UIView {
        
        let myResourceOptions = ResourceOptions(accessToken: (Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String)!)
        let latitude: Double = 40.710610319784524
        let longitude: Double = -73.91524212298014

        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let cameraOptions = CameraOptions(center: centerCoordinate, zoom: 14.4, bearing: -25, pitch: 0)
        
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions, styleURI: StyleURI(rawValue: "mapbox://styles/fiigmnt/cl4evbfs6001q14lqhwnmjo11"))

        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: myMapInitOptions)

        // Create location identifier icon "puck"
        let puckImage = Puck2DConfiguration(topImage: UIImage(named: "me-pin"), bearingImage: UIImage(named: "me-pin"), scale: .constant(1.0), showsAccuracyRing: false)

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.options.puckType = .puck2D(puckImage)

        // Map view options [disable pitch, hide elements]
        mapView.gestures.options.pitchEnabled = false
        mapView.ornaments.options.logo.margins = .init(x: -10000, y: 0)
        mapView.ornaments.options.attributionButton.margins = .init(x: -10000, y: 0)
        mapView.ornaments.options.scaleBar.visibility = .hidden
        mapView.ornaments.options.compass.visibility = .hidden

        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let mapView = uiView as? MapView {
            loadMiras()
            addDummyAnnotations(mapView: mapView)
        }
    }
    private func loadMiras() {
        viewModel.getMiras(location: CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.91524212298014), userId: "0", accessToken: "0")
    }
    
    private func addDummyAnnotations(mapView: MapView) {
        
        mapView.viewAnnotations.removeAll()
        let miras = Mira.dummyMiras()
        for mira in miras {
            let options = ViewAnnotationOptions(
                geometry: Point(mira.coordinate),
                width: 40,
                height: 40,
                allowOverlap: false,
                anchor: .center
            )

//            var pointAnnotation = PointAnnotation(coordinate: mira.coordinate)
//            pointAnnotation.setImageFromServerURL(mira.imageUrl)
//            pointAnnotation.iconAnchor = .bottom
//            let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
//            pointAnnotationManager.annotations = [pointAnnotation]
            try? mapView.viewAnnotations.add(annotationView(mira: mira), options: options)
        }

    }
    private func annotationView(mira: Mira) -> UIView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
        if mira.isFriend {
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = Colors.green.color.cgColor
        }
        imageView.setImage(from: mira.imageUrl)
        return imageView
    }
    
}

extension UIImageView {
    func setImage(from url: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let urlObj = URL(string: url) else { return }
        setImage(from: urlObj, contentMode: mode)
    }
    func setImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}

extension PointAnnotation {

    mutating func setImageFromServerURL(_ URLString: String) {

        self.image = nil
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: imageServerUrl), let data =  try? Data(contentsOf: url), let img = UIImage(data: data) {
            let circleImage = circularScaleAndCropImage(img, size: CGSize(width: 40, height: 40))
            self.image = .init(image: circleImage, name: "profile")
//            URLSession.shared.dataTask
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
//                    DispatchQueue.main.sync {
//                        self.image = .init(image: UIImage(named: "profile-48")!, name: "profile")
//
//                    }
//                    return
//                }
//                DispatchQueue.main.sync {
//                    if let data = data {
//                        if let downloadedImage = UIImage(data: data) {
//
//                            self.image = .init(image: downloadedImage, name: "profile")
//
//                        }
//                    }
//                }
//            }).resume()
        } else {
            self.image = .init(image: UIImage(named: "profile-48")!, name: "profile")
        }
    }
    func circularScaleAndCropImage(_ image: UIImage, size: CGSize) -> UIImage{
        // This function returns a newImage, based on image, that has been:
        // - scaled to fit in (CGRect) rect
        // - and cropped within a circle of radius: rectWidth/2
        //Create the bitmap graphics context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(size.width), height: CGFloat(size.height)), false, 0.0)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        //Get the width and heights
        let imageWidth: CGFloat = image.size.width
        let imageHeight: CGFloat = image.size.height
        let rectWidth: CGFloat = size.width
        let rectHeight: CGFloat = size.height
        //Calculate the scale factor
        let scaleFactorX: CGFloat = rectWidth / imageWidth
        let scaleFactorY: CGFloat = rectHeight / imageHeight
        //Calculate the centre of the circle
        let imageCentreX: CGFloat = rectWidth / 2
        let imageCentreY: CGFloat = rectHeight / 2
        // Create and CLIP to a CIRCULAR Path
        // (This could be replaced with any closed path if you want a different shaped clip)
        let radius: CGFloat = rectWidth / 2
        context?.beginPath()
        context?.addArc(center: CGPoint(x: imageCentreX, y: imageCentreY), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * Float.pi), clockwise: false)
        context?.closePath()
        context?.clip()
        //Set the SCALE factor for the graphics context
        //All future draw calls will be scaled by this factor
        context?.scaleBy(x: scaleFactorX, y: scaleFactorY)
        // Draw the IMAGE
        let myRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: imageWidth, height: imageHeight)
        image.draw(in: myRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
/*
 getmiras by saad(location, zoomLevel){
    miras [
      m1 { creator { k }
      m2 { creator { k }
    ]
    viewedMira[ m1 ] for loggedinuser
 }
  
 */
