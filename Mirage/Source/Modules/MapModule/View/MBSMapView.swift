//
//  MBSMapView.swift
//  Mirage
//
//  Created by fiigmnt on 9/10/23.
//

@_spi(Experimental) import MapboxMaps
import MapKit
import SwiftUI

@available(iOS 14.0, *)
struct MBSMapView: View {
    @EnvironmentObject var stateManager: StateManager
    @ObservedObject private var viewModel = MapViewModel()
    @ObservedObject private var locationManager = LocationManager.shared
    
    let bearingType = PuckBearing.heading
    
    @Binding var selectedMira: Mira?
    @Binding var showCollectedByList: Bool
    var isProfile: Bool = false
    
    @State private var viewport: Viewport = .camera(zoom: 17, bearing: 0, pitch: 40)
    @State private var mapHasMoved: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            MapReader { proxy in
                ZStack {
                    Map(viewport: $viewport) {
                        if let miras = viewModel.miras {
                            ForEvery(isProfile ? profileFilter(miras) : miras) { mira in
                                let location = CLLocationCoordinate2D(latitude: mira.location.latitude, longitude: mira.location.longitude)
                                ViewAnnotation(location, allowOverlap: true) {
                                    AsyncImage(url: URL(string: mira.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    placeholder: {
                                        ProgressView()
                                            .foregroundColor(Colors.white8p.swiftUIColor)
                                    }
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        print("Tapped: \(mira.id)")
                                        selectedMira = mira
                                        showCollectedByList = true
                                    }
                                }
                            }
                        }
                        
                        Puck2D(bearing: bearingType)
                            .topImage(UIImage(named: "me-pin"))
                            .bearingImage(UIImage(named: "me-pin"))
                            .shadowImage(UIImage(named: "me-pin"))
                            .scale(1.25)
                    }
                    .mapStyle(.standard(lightPreset: .night, showPointOfInterestLabels: false, showTransitLabels: false, showPlaceLabels: false))
                    .onCameraChanged { _ in
                        mapHasMoved = true
                    }
                    .onAppear {
                        guard let map = proxy.map else { return }
                        map.setCamera(to: .init(center: locationManager.location))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            mapHasMoved = false
                        }
                    }
                    
                    Button {
                        withViewportAnimation(.default(maxDuration: 0.75)) {
                            viewport = .camera(center: locationManager.location)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    self.mapHasMoved = false
                                }
                            }
                        }
                    } label: {
                        Images.findMe24.swiftUIImage
                    }
                    .opacity(mapHasMoved ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2), value: mapHasMoved)
                }
                .frame(width: geo.size.width, height: geo.size.height * 1.5)
            }
        }
    }
    
    func profileFilter(_ miras: [Mira]) -> [Mira] {
        var filteredMiras = miras
        
        if let user = stateManager.selectedUserOnMap {
            let createdMiraIds = user.createdMiraIds
            let collectedMiraIds = user.collectedMiraIds
            let userMiraIds = (createdMiraIds ?? []) + (collectedMiraIds ?? [])
            filteredMiras = miras.filter { userMiraIds.contains($0.id) }
        }
        return filteredMiras
    }
}
