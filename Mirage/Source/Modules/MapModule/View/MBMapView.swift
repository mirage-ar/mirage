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
    
    @Binding var selectedMira: Mira?
    @Binding var showCollectedByList: Bool

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
    
        mapView.mapboxMap.onNext(event: .cameraChanged) { event in
            print(event)
        }
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
        
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let mapView = uiView as? MapView {
            if $viewModel.hasLoadedMiras.wrappedValue && viewState != .updated {
                refreshMirasOnMap(mapView: mapView, context: context)
            }
        }

    }
    func loadMiras() {
        if !viewModel.isLoading {
            viewState = .fetching
            viewModel.getMiras(location: CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.91524212298014), zoomLevel: 7)
        }
    }
    
    private func refreshMirasOnMap(mapView: MapView, context: Context) {
        guard let miras = viewModel.miras else { return } //server data
//        let miras = Mira.dummyMiras() //commented for dummy miras
        
        mapView.mapboxMap.onNext(event: .cameraChanged) { event in
            print(event)
        }
        mapView.viewAnnotations.removeAll()
        let userLocation = LocationManager.shared.location
        var i = 0
        for mira in miras {
            let options = ViewAnnotationOptions(
                geometry: Point(mira.location),
                width: 40,
                height: 40,
                allowOverlap: true,
                anchor: .center
            )
            try? mapView.viewAnnotations.add(annotationView(mira: mira, sourceLocation: userLocation, tag: i, context: context), options: options)
            i += 1
        }
        
    }

    
    private func annotationView(mira: Mira, sourceLocation: CLLocationCoordinate2D?, tag: Int, context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 40))

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
        if mira.isFriend {
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = Colors.green.color.cgColor
        }
        imageView.setImage(from: mira.imageUrl)
        view.addSubview(imageView)
        
        let descriptionView = UIView(frame: CGRect(x: 45, y: 0, width: 100, height: 40))
        descriptionView.backgroundColor = Colors.g1DarkGrey.color
        descriptionView.layer.cornerRadius = 10
        descriptionView.clipsToBounds = true
        descriptionView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 80, height: 20))
        nameLabel.text = mira.creator.userName
        nameLabel.setFont(.body3, textColor: Colors.white)
        descriptionView.addSubview(nameLabel)
        
        let distanceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 20))
        distanceLabel.textColor = Colors.white.color
        distanceLabel.setFont(.body3, textColor: Colors.white)

        if let userCoordinates = sourceLocation {
            let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
            let miraLocation = CLLocation(latitude: mira.location.latitude, longitude: mira.location.longitude)
            let distance = userLocation.distance(from: miraLocation)
            distanceLabel.text = distanceString(distance: distance)
        } else {
            distanceLabel.text = "nan"
        }
 
        let collecedMiraIconView = UIImageView(image: Images.collectMiraWhite.image)
        collecedMiraIconView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        collecedMiraIconView.contentMode = .scaleAspectFit
        
        let collectedMiraCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        collectedMiraCountLabel.text = "\(mira.collectors?.count ?? 0)"
        collectedMiraCountLabel.setFont(.body3, textColor: Colors.white)
        
        let stack = UIStackView(arrangedSubviews: [distanceLabel, collecedMiraIconView, collectedMiraCountLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .equalCentering
        stack.frame = CGRect(x: 5, y: 20, width: 80, height: 20)
        descriptionView.addSubview(stack)
        
        view.addSubview(descriptionView)
        view.addGestureRecognizer(context.coordinator.tapGesture())
        view.tag = tag
        return view
    }
    
    func distanceString(distance: Double) -> String {
        if distance >= 1000 {
            return "\((distance/1000).formattedStringValue)" + "km"
        } else {
            return "\(distance.clean)m"
        }
    }
    enum ViewState: Int {
        case empty = 1, fetching, updating, updated
    }

}

extension MBMapView {
    class MapViewCoordinator: NSObject, AnnotationInteractionDelegate {
        var parent: MBMapView
        
        init(_ parent: MBMapView) {
            self.parent = parent
        }
        func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
            print(annotations)
            //TODO: Use this method in future when it is working properly
        }
        
        @objc func pinTapped(gesture: UITapGestureRecognizer) {
            guard let index = gesture.view?.tag else { return }
            
            if let mira = parent.viewModel.miras?[index] {
                parent.selectedMira = mira
                parent.showCollectedByList = true
                print(parent.selectedMira?.creator.userName ?? "")
            }
        }
        func tapGesture() -> UITapGestureRecognizer {
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(pinTapped(gesture:)))
            return gesture
        }

    }

}
