//
//  MBSMapView.swift
//  Mirage
//
//  Created by fiigmnt on 9/10/23.
//

@_spi(Experimental) import MapboxMaps
import MapKit
import SwiftUI
import Combine

@available(iOS 14.0, *)
struct MBSMapView: View {
    @EnvironmentObject var stateManager: StateManager
    @ObservedObject private var viewModel = MapViewModel()
    @ObservedObject private var locationManager = LocationManager.shared
    @State private var miraAddedListenSubscription: AnyCancellable? //for combine subscription
    
    let bearingType = PuckBearing.heading
    
    @Binding var selectedMira: Mira?
    @Binding var showCollectedByList: Bool
    var user: User? = nil
    
    @State private var viewport: Viewport = .camera(zoom: 17, bearing: 0, pitch: 40)
    @State private var mapHasMoved: Bool = false
    @State private var userLocation: CLLocationCoordinate2D?
    
    var body: some View {
        GeometryReader { geo in
            MapReader { proxy in
                ZStack {
                    Map(viewport: $viewport) {
                        if let miras = viewModel.miras {
                            ForEvery(user != nil ? profileFilter(miras) : miras) { mira in
                                let location = CLLocationCoordinate2D(latitude: mira.location.latitude, longitude: mira.location.longitude)
                                ViewAnnotation(location, allowOverlap: true) {
                                    AsyncImage(url: URL(string: mira.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    placeholder: {
                                        // None
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
                    .mapStyle(.standard(lightPreset: getLightPreset(), showPointOfInterestLabels: false, showTransitLabels: false, showPlaceLabels: false))
                    .onCameraChanged { _ in
                        mapHasMoved = true
                    }
                    .onAppear {
                        userLocation = locationManager.location
                        
                        guard let map = proxy.map else { return }
                        map.setCamera(to: .init(center: locationManager.location))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            mapHasMoved = false
                        }
                    }
                    
                    VStack {
                        Spacer()
                        Button {
                            withViewportAnimation(.default(maxDuration: 0.75)) {
                                viewport = .camera(center: locationManager.location, bearing: 0, pitch: 40)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        self.mapHasMoved = false
                                    }
                                }
                            }
                        } label: {
                            Images.findMe24.swiftUIImage
                                .foregroundColor(Colors.green.swiftUIColor)
                                .frame(width: 48, height: 48)
                                .background(Colors.g3Grey.just.opacity(0.9))
                                .clipShape(Circle())
                            //                            .padding(.bottom, 30)
                        }
                        .offset(y: -100)
                        .padding(.bottom, user != nil ? 48 : 120)
                        .opacity(mapHasMoved ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.2), value: mapHasMoved)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height + 100)
            }
        }
    }
    
    func profileFilter(_ miras: [Mira]) -> [Mira] {
        var filteredMiras = miras
        
        if let user = user {
            let createdMiraIds = user.createdMiraIds
            let collectedMiraIds = user.collectedMiraIds
            print("MIRA IDS: \(createdMiraIds)")
            let userMiraIds = (createdMiraIds ?? []) + (collectedMiraIds ?? [])
            print("MIRA IDS: \(userMiraIds)")
            filteredMiras = miras.filter { userMiraIds.contains($0.id) }
        }
        return filteredMiras
    }
    
    func getLightPreset() -> StandardLightPreset {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        switch currentHour {
        case 5..<7:
            return .dawn
        case 7..<18:
            return .day
        case 18..<20:
            return .dusk
        default:
            return .night
        }
    }
    
    func handleOnChangeOfMiraSubscription() {
        miraAddedListenSubscription = stateManager.miraAddedPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { mira in
                debugPrint("Miraadded Subscription: \(mira)")
                self.viewModel.handleMiraAdded(mira: mira)
            })

    }

}
