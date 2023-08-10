//
//  CollectedByUsersView.swift
//  Mirage
//
//  Created by Saad on 21/06/2023.
//

import SwiftUI
import MapKit

struct CollectedByUsersView: View {
    @EnvironmentObject var stateManager: StateManager
    @Binding var selectedMira: Mira?

    let paddingMargin = 20.0

    var body: some View {
        ZStack {
            Colors.black70p.swiftUIColor
                .edgesIgnoringSafeArea(.all)

            List {
                Section {
                    if let selectedMira = selectedMira {
                        ForEach(selectedMira.collectors ?? [], id: \.self) { user in
                            UserListRow(user: user)
                                .listRowBackground(Color.clear)
                                .padding([.leading, .trailing], -paddingMargin)
                                .onTapGesture {
                                    print("UPDATE: selected user set to: \(String(describing: user.userName))")
                                    // TODO: update to statemanager method (no mutations)
                                    stateManager.selectedUserOnMap = user
                                }
                        }
                    }
                } header: {
                    VStack(alignment: .leading) {
                        HStack(spacing: 1) {
                            Images.collectMiraWhite.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            Text("\(selectedMira?.collectors?.count ?? 0)")
                                .font(.body1)
                            Spacer()
                            Button {
                                if selectedMira?.creator.id == stateManager.loggedInUser?.id {
                                    stateManager.selectedUserOnMap = stateManager.loggedInUser
                                } else {
                                    stateManager.selectedUserOnMap = selectedMira?.creator
                                }
                            } label: {
                                Text("Mira by " + (selectedMira?.creator.userName ?? "NaN"))
                                    .font(.body2)
                                Images.arrowR24.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .padding([.leading, .trailing], -paddingMargin)
                        Divider()
                            .overlay(Colors.g4LightGrey.swiftUIColor)
                            .padding([.trailing, .leading], -paddingMargin)
                        Text("Collected By")
                            .font(.body2)
                            .padding([.leading, .trailing], -paddingMargin)

                        Spacer()
                    }

                } footer: {
                    LargeButton(title: "Navigate") {
                        if let mira = selectedMira, let userLoc = LocationManager.shared.location {
                            
                            let source = MKMapItem(placemark: MKPlacemark(coordinate: userLoc))
                            source.name = "Your Location"
                                    
                            let destination = MKMapItem(placemark: MKPlacemark(coordinate: mira.location))
                            destination.name = "Mira"
                                    
                            MKMapItem.openMaps(
                              with: [source, destination],
                              launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                            )
                        }

                        debugPrint("google map")
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}
