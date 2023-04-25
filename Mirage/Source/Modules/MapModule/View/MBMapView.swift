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
            if $viewModel.hasLoadedMiras.wrappedValue && viewState != .updated {
                refreshMirasOnMap(mapView: mapView)
                addSymbolClusteringLayers(mapView: mapView)
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
//        guard let miras = viewModel.miras else { return } //server data
        let miras = Mira.dummyMiras()
        var annotations = [PointAnnotation]()
        
        mapView.viewAnnotations.removeAll()
        for mira in miras {
            let options = ViewAnnotationOptions(
                geometry: Point(mira.location),
                width: 40,
                height: 40,
                allowOverlap: false,
                anchor: .center
            )
//            try? mapView.viewAnnotations.add(annotationView(mira: mira), options: options)
            
            var pointAnnotation = PointAnnotation(coordinate: mira.location)
            pointAnnotation.image = .init(image: Images.profile48.image, name: "fire-station-11")
            annotations.append(pointAnnotation)

        }
        
        DispatchQueue.main.async {
            self.createClusters(annotations: annotations, mapView: mapView)
        }

    }
    func createClusters(annotations: [PointAnnotation], mapView: MapView) {
        let circleRadiusExpression = Exp(.step) {
            Exp(.get) {"point_count"}
            25
            50
            30
            100
            35
        }

        let circleColorExpression = Exp(.step) {
            Exp(.get) {"point_count"}
            UIColor.yellow
            10
            UIColor.green
            50
            UIColor.cyan
            100
            UIColor.red
            150
            UIColor.orange
            250
            UIColor.blue
        }

        // Create expression to get the total count of hydrants in a cluster
        let sumExpression = Exp {
            Exp(.sum) {
                Exp(.accumulated)
                Exp(.get) { "sum" }
            }
            1
        }

        // Create a cluster property to add to each cluster
        let clusterProperties: [String: Expression] = [
            "sum": sumExpression
        ]

        let textFieldExpression = Exp(.switchCase) {
            Exp(.has) { "point_count" }
            Exp(.concat) {
                Exp(.string) { "Count:\n" }
                Exp(.get) {"sum"}
            }
            Exp(.string) { "" }
        }

        // Select the options for clustering and pass them to the PointAnnotationManager to display
        let clusterOptions = ClusterOptions(circleRadius: .expression(circleRadiusExpression),
                                            circleColor: .expression(circleColorExpression),
                                            textColor: .constant(StyleColor(.black)),
                                            textField: .expression(textFieldExpression),
                                            clusterRadius: 75,
                                            clusterProperties: clusterProperties)
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager(id: clusterLayerID, clusterOptions: clusterOptions)
        pointAnnotationManager.annotations = annotations

        // Additional properties on the text and circle layers can be modified like this below
        // To modify the text layer use: "mapbox-iOS-cluster-text-layer-manager-" and SymbolLayer.self
        do {
            try mapView.mapboxMap.style.updateLayer(withId: "mapbox-iOS-cluster-circle-layer-manager-" + clusterLayerID, type: CircleLayer.self) { layer in
                layer.circleStrokeColor = .constant(StyleColor(.black))
                layer.circleStrokeWidth = .constant(3)
            }
        } catch {
            print("Updating the layer failed: \(error.localizedDescription)")
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

extension MBMapView {
    func addSymbolClusteringLayers(mapView: MapView) {
        let style = mapView.mapboxMap.style
        // The image named `fire-station-11` is included in the app's Assets.xcassets bundle.
        // In order to recolor an image, you need to add a template image to the map's style.
        // The image's rendering mode can be set programmatically or in the asset catalogue.
        let image = Images.profile48.image.withRenderingMode(.alwaysTemplate)

        // Add the image tp the map's style. Set `sdf` to `true`. This allows the icon images to be recolored.
        // For more information about `SDF`, or Signed Distance Fields, see
        // https://docs.mapbox.com/help/troubleshooting/using-recolorable-images-in-mapbox-maps/#what-are-signed-distance-fields-sdf
        try! style.addImage(image, id: "profile", sdf: true)

        // Fire_Hydrants.geojson contains information about fire hydrants in the District of Columbia.
        // It was downloaded on 6/10/21 from https://opendata.dc.gov/datasets/DCGIS::fire-hydrants/about
        let url = Bundle.main.url(forResource: "Fire_Hydrants", withExtension: "geojson")!

        // Create a GeoJSONSource using the previously specified URL.
        var source = GeoJSONSource()
        source.data = .url(url)

        // Enable clustering for this source.
        source.cluster = true
        source.clusterRadius = 75

        // Create expression to identify the max flow rate of one hydrant in the cluster
        // ["max", ["get", "FLOW"]]
        let maxExpression = Exp(.max) {Exp(.get) { "FLOW" }}

        // Create expression to determine if a hydrant with EngineID E-9 is in the cluster
        // ["any", ["==", ["get", "ENGINEID"], "E-9"]]
        let ine9Expression = Exp(.any) {
            Exp(.eq) {
                Exp(.get) { "ENGINEID" }
                "E-9"
            }
        }

        // Create expression to get the sum of all of the flow rates in the cluster
        // [["+", ["accumulated"], ["get", "sum"]], ["get", "FLOW"]]
        let sumExpression = Exp {
            Exp(.sum) {
                Exp(.accumulated)
                Exp(.get) { "sum" }
            }
            Exp(.get) { "FLOW" }
        }

        // Add the expressions to the cluster as ClusterProperties so they can be accessed below
        let clusterProperties: [String: Expression] = [
            "max": maxExpression,
            "in_e9": ine9Expression,
            "sum": sumExpression
        ]
        source.clusterProperties = clusterProperties

        let sourceID = "fire-hydrant-source"

        var clusteredLayer = createClusteredLayer()
        clusteredLayer.source = sourceID

        var unclusteredLayer = createUnclusteredLayer()
        unclusteredLayer.source = sourceID

        // `clusterCountLayer` is a `SymbolLayer` that represents the point count within individual clusters.
        var clusterCountLayer = createNumberLayer()
        clusterCountLayer.source = sourceID

        // Add the source and two layers to the map.
        try! style.addSource(source, id: sourceID)
        try! style.addLayer(clusteredLayer)
        try! style.addLayer(unclusteredLayer, layerPosition: .below(clusteredLayer.id))
        try! style.addLayer(clusterCountLayer)
    }

    func createClusteredLayer() -> CircleLayer {
        // Create a symbol layer to represent the clustered points.
        var clusteredLayer = CircleLayer(id: "clustered-circle-layer")

        // Filter out unclustered features by checking for `point_count`. This
        // is added to clusters when the cluster is created. If your source
        // data includes a `point_count` property, consider checking
        // for `cluster_id`.
        clusteredLayer.filter = Exp(.has) { "point_count" }

        // Set the color of the icons based on the number of points within
        // a given cluster. The first value is a default value.
        clusteredLayer.circleColor = .expression(Exp(.step) {
            Exp(.get) { "point_count" }
            UIColor.systemGreen
            50
            UIColor.systemBlue
            100
            UIColor.systemRed
        })

        clusteredLayer.circleRadius = .constant(25)

        return clusteredLayer
    }

    func createUnclusteredLayer() -> SymbolLayer {
        // Create a symbol layer to represent the points that aren't clustered.
        var unclusteredLayer = SymbolLayer(id: "unclustered-point-layer")

        // Filter out clusters by checking for `point_count`.
        unclusteredLayer.filter = Exp(.not) {
            Exp(.has) { "point_count" }
        }
        unclusteredLayer.iconImage = .constant(.name("fire-station-icon"))
        unclusteredLayer.iconColor = .constant(StyleColor(.white))

        // Rotate the icon image based on the recorded water flow.
        // The `mod` operator allows you to use the remainder after dividing
        // the specified values.
        unclusteredLayer.iconRotate = .expression(Exp(.mod) {
            Exp(.get) { "FLOW" }
            360
        })

        return unclusteredLayer
    }

    func createNumberLayer() -> SymbolLayer {
        var numberLayer = SymbolLayer(id: "cluster-count-layer")

        // check whether the point feature is clustered
        numberLayer.filter = Exp(.has) { "point_count" }

        // Display the value for 'point_count' in the text field
        numberLayer.textField = .expression(Exp(.get) { "point_count" })
        numberLayer.textSize = .constant(12)
        return numberLayer
    }

//    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
//        let point = gestureRecognizer.location(in: mapView)
//
//        // Look for features at the tap location within the clustered and
//        // unclustered layers.
//        mapView.mapboxMap.queryRenderedFeatures(with: point,
//                                                options: RenderedQueryOptions(layerIds: ["unclustered-point-layer", "clustered-circle-layer"],
//                                                filter: nil)) { [weak self] result in
//            switch result {
//            case .success(let queriedFeatures):
//                // Return the first feature at that location, then pass attributes to the alert controller.
//                // Check whether the feature has values for `ASSETNUM` and `LOCATIONDETAIL`. These properties
//                // come from the fire hydrant dataset and indicate that the selected feature is not clustered.
//                if let selectedFeatureProperties = queriedFeatures.first?.feature.properties,
//                   case let .string(featureInformation) = selectedFeatureProperties["ASSETNUM"],
//                   case let .string(location) = selectedFeatureProperties["LOCATIONDETAIL"] {
//                    self?.showAlert(withTitle: "Hydrant \(featureInformation)", and: "\(location)")
//                // If the feature is a cluster, it will have `point_count` and `cluster_id` properties. These are assigned
//                // when the cluster is created.
//                } else if let selectedFeatureProperties = queriedFeatures.first?.feature.properties,
//                  case let .number(pointCount) = selectedFeatureProperties["point_count"],
//                  case let .number(clusterId) = selectedFeatureProperties["cluster_id"],
//                  case let .number(maxFlow) = selectedFeatureProperties["max"],
//                  case let .number(sum) = selectedFeatureProperties["sum"],
//                  case let .boolean(in_e9) = selectedFeatureProperties["in_e9"] {
//                // If the tap landed on a cluster, pass the cluster ID and point count to the alert.
//                    let inEngineNine = in_e9 ? "Some hydrants belong to Engine 9." : "No hydrants belong to Engine 9."
//                    self?.showAlert(withTitle: "Cluster ID \(Int(clusterId))", and: "There are \(Int(pointCount)) hydrants in this cluster. The highest water flow is \(Int(maxFlow)) and the collective flow is \(Int(sum)). \(inEngineNine)")
//                }
//            case .failure(let error):
//                self?.showAlert(withTitle: "An error occurred: \(error.localizedDescription)", and: "Please try another hydrant")
//            }
//        }
//    }

}
