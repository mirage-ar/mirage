//
//  HomeView.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import SwiftUI
// import MapboxMaps

struct HomeView: View {
    @EnvironmentObject var stateManager: StateManager

    @State var showArView = false
    @State var showProfileView = false
    @State var showCollectedByList = false
    @State var selectedMira: Mira?
    @State var mapViewModel = MapViewModel()
    @State var selectedUserOnMapId: UUID?
    
    let buttonSize = 60.0

    var body: some View {
        NavigationStack {
            ZStack {
                MBSMapView(viewModel: mapViewModel, selectedMira: $selectedMira, showCollectedByList: $showCollectedByList)

                VStack {
                    HStack {
                        Spacer()
                        if stateManager.loggedInUser != nil {
                            Button {
                                selectedUserOnMapId = stateManager.loggedInUser?.id
                                showProfileView = true
                            } label: {
                                AsyncImage(url: URL(string: stateManager.loggedInUser!.profileImage)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Colors.g3Grey.just)
                                .clipShape(Circle())
                            }
                            .padding(.top, 48)
                        }
                    }
                    .padding()
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
                    .padding(.bottom, 48)

                }
            }
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showArView, content: {
                NavigationRoute.homeToARCameraView.screen
            })
            .fullScreenCover(isPresented: $showProfileView, onDismiss: {
                stateManager.selectedUserOnMap = nil
            }, content: {
                NavigationRoute.profile(userId: selectedUserOnMapId ?? UUID()).screen
            })
            .sheet(isPresented: $showCollectedByList) {
                NavigationRoute.miraCollectedByUsersList(mira: $selectedMira) { selectedUser in
                    
                    showCollectedByList = false
                    // TODO: need to be able to show profile view over ARView
                    showArView = false
                    debugPrint(selectedUser.debugDescription)
                    self.selectedUserOnMapId = selectedUser?.id
                    stateManager.selectedUserOnMap = selectedUser
                    // fix for swiftUI animation collision
                    if let _ = selectedUser {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showProfileView = true
                        }
                    }

                }.screen
                    .presentationDetents([.medium, .large])
            }
            }
        .onChange(of: selectedUserOnMapId) { newId in
                showCollectedByList = false
        }
        .accentColor(Colors.white.swiftUIColor)
        .onAppear {
            hideKeyboard()
        }
    }
}
