//
//  HomeView.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import SwiftUI
// import MapboxMaps

struct HomeView: View {
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

    @ObservedObject private var viewModel = HomeViewModel()
    @State var showArView = false
    @State var showProfileView = false
    @State var selectedMiraOnMap: Mira?
    @State var showCollectedByList = false
    @State var selectedMira: Mira?
    @State var selectedUser: User?
    
    let miras = Mira.dummyMiras()
    let buttonSize = 48.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                MBMapView(selectedMira: $selectedMira, showCollectedByList: $showCollectedByList)
                ZStack {
                    VStack {
                        HStack {
                            Spacer()

                            VStack {
                                if viewModel.currentUser != nil {
                                    Button {
                                        print("UPDATE: show user profile for: \(String(describing: selectedUser?.userName))")
                                        selectedUser = viewModel.currentUser
                                        showProfileView = true
                                    } label: {
                                        AsyncImage(url: URL(string: viewModel.currentUser!.profileImage)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: buttonSize, height: buttonSize)
                                        
                                        .background(Colors.g3Grey.just)
                                        .clipShape(Circle())
                                    }
                                }
                                Spacer()

                                Button {
                                    showArView = true
                                    print("UPDATE: go to ARView")
                                } label: {
                                    Images.goAr32.swiftUIImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                }
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Colors.g3Grey.just)
                                .clipShape(Circle())
                                .padding(.bottom, 50)
                            }
                            .padding(.top, 70)
                            .padding(.trailing, 20)
                        }
                        Spacer()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showArView, content: {
                NavigationRoute.homeToARCameraView.screen
            })
            .fullScreenCover(isPresented: $showProfileView, content: {
                NavigationRoute.myProfile(userId: selectedUser?.id ?? "").screen
            })
            .sheet(isPresented: $showCollectedByList) {
                NavigationRoute.miraCollectedByUsersList(mira: $selectedMira, selectedUser: $selectedUser).screen
                    .presentationDetents([.medium, .large])
            }
            .onChange(of: selectedUser) { selectedUser in
                showCollectedByList = false
                // fix for swiftUI animation collision
                if let _ = selectedUser {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showProfileView = true
                    }
                }
            }
        }
        .accentColor(Colors.white.swiftUIColor)
    }
}
