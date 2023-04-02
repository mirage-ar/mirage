//
//  HomeView.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    let miras = Mira.dummyMiras()
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: miras) { location in
            MapAnnotation(coordinate: location.coordinate) {
                NavigationLink {
                    Text(location.name)
                } label: {
                    Circle()
                        .stroke(.red, lineWidth: 3)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .navigationTitle("NY Explorer")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
