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

    let buttonSize = 60.0

    var body: some View {
        NavigationStack {
            ZStack {
                MBSMapView(selectedMira: $selectedMira, showCollectedByList: $showCollectedByList)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Spacer()
                        if stateManager.loggedInUser != nil {
                            Button {
                                stateManager.selectedUserOnMap = stateManager.loggedInUser
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
                    .padding(.bottom, 30)

                }
            }
            .fullScreenCover(isPresented: $showArView, content: {
                NavigationRoute.homeToARCameraView.screen
            })
            .fullScreenCover(isPresented: $showProfileView, onDismiss: {
                stateManager.selectedUserOnMap = nil
            }, content: {
                NavigationRoute.myProfile(userId: stateManager.selectedUserOnMap?.id.uuidString ?? "").screen
            })
            .sheet(isPresented: $showCollectedByList) {
                NavigationRoute.miraCollectedByUsersList(mira: $selectedMira).screen
                    .presentationDetents([.medium, .large])
            }
            .onChange(of: stateManager.selectedUserOnMap) { [selectedUserOnMap = self.stateManager.selectedUserOnMap] selectedUser in
                showCollectedByList = false

                // TODO: need to be able to show profile view over ARView
                showArView = false
                debugPrint(selectedUserOnMap.debugDescription)
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
