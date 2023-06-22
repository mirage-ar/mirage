//
//  HomeView.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import SwiftUI
//import MapboxMaps

struct HomeView: View {
    
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @ObservedObject private var viewModel = HomeViewModel()
    let miras = Mira.dummyMiras()
    let buttonWidth = 48.0
    @State var showArView = false
    @State var showProfileView = false
    @State var selectedMiraOnMap: Mira?
    @State var showCollectedByList = false
    @State var selectedMira: Mira = .dummy
    @State var selectedUser: User = .dummy
    @State var showProfile: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                MBMapView(selectedMira: $selectedMira, showCollectedByList: $showCollectedByList)
                ZStack {
                    VStack {
                        HStack{
                            Button {
                                print("Button go to Location")
                            } label: {
                                VStack {
                                    HStack {
                                        AsyncImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVS8dxHAKdr2oZhV-kuh3DnohvK50EUUA8pg&usqp=CAU")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: buttonWidth, height: 72)
                                        Text("New York")
                                            .foregroundColor(Colors.white.just)
                                    }
                                    Spacer()
                                }
                                .padding(.top, 50)
                                .padding(.leading, 20)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Button {
                                    print("Button go to profile")
                                    showProfileView = true
                                } label: {
                                    AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: buttonWidth, height: buttonWidth)
                                }
                                .background(Colors.g3Grey.just)
                                .clipShape(Circle())

                                
                                Button {
                                    print("Button go to Reaction")
                                } label: {
                                    Images.reaction32.swiftUIImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)

                                }
                                .frame(width: buttonWidth, height: buttonWidth)
                                .background(Colors.g3Grey.just)
                                .clipShape(Circle())

                                
                                Button {
                                    print("Button go to filters")
                                } label: {
                                    Images.mapFilterAll24.swiftUIImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)

                                }
                                .frame(width: buttonWidth, height: buttonWidth)
                                .background(Colors.g3Grey.just)
                                .clipShape(Circle())

                                Spacer()
                                
                                Button {
                                    showArView = true
                                    print("Button go to AR View")
                                } label: {
                                    Images.goAr32.swiftUIImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)

                                }
                                .frame(width: buttonWidth, height: buttonWidth)
                                .background(Colors.g3Grey.just)
                                .clipShape(Circle())
                                .padding(.bottom, 50)
                            }
                            .padding(.top, 50)
                            .padding(.trailing, 20)
                        }
                        Spacer()                        
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $showArView) {
                NavigationRoute.homeToARCameraView.screen
            }
            .fullScreenCover(isPresented: $showProfileView, content: {
                NavigationRoute.myProfile.screen
            })
            .sheet(isPresented:$showCollectedByList) {
                NavigationRoute.miraCollectedByUsersList(mira: $selectedMira, showProfile: $showProfile, selectedUser: $selectedUser).screen
                    .presentationDetents([.medium, .large])
                
            }
        }
        .accentColor(Colors.white.swiftUIColor)
    }
    
}


