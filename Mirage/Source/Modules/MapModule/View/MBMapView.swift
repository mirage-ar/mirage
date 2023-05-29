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
    @State var viewState: ViewState = .empty
    let clusterLayerID = "groupedMiras"

    func makeUIView(context: Context) -> some UIView {
        
        let myResourceOptions = ResourceOptions(accessToken: (Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String)!)
        let userLocation = LocationManager.shared.location
        let latitude: Double = userLocation?.latitude ?? 40.70290414346796
        let longitude: Double = userLocation?.longitude ?? -73.95591309248328
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
            if $viewModel.hasLoadedMiras.wrappedValue && viewState != .updated {
                refreshMirasOnMap(mapView: mapView)
            }
        }

    }
    func loadMiras() {
        if !viewModel.isLoading {
            viewState = .fetching
            viewModel.getMiras(location: CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.91524212298014), userId: "0", accessToken: "0")
        }
    }
    
    private func refreshMirasOnMap(mapView: MapView) {
        guard let miras = viewModel.miras else { return } //server data
//        let miras = Mira.dummyMiras() //commented for dummy miras
        
        mapView.viewAnnotations.removeAll()
        for mira in miras {
            let options = ViewAnnotationOptions(
                geometry: Point(mira.location),
                width: 40,
                height: 40,
                allowOverlap: true,
                anchor: .center
            )
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
    enum ViewState: Int {
        case empty = 1, fetching, updating, updated
    }
    
}

