//
//  MyProfileView.swift
//  Mirage
//
//  Created by Saad on 06/11/2023.
//

import SwiftUI

struct MyProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var stateManager: StateManager
    @ObservedObject private var viewModel: UserProfileViewModel
    @State var mapViewModel = MapViewModel()
    @State var goToSettings = false
    @State var showCollectedByList = false
    @State var gotoAotherUserProfile = false
    @State var selectedMira: Mira?
    @State var selectedUserOnMapId: UUID?

    init(userId: UUID) {
        viewModel = UserProfileViewModel(userId: userId)
    }
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    VStack {
                        ProfileInfoView(imageUrl: stateManager.loggedInUser?.profileImage ?? "", userName: stateManager.loggedInUser?.userName ?? "", profileDescription: stateManager.loggedInUser?.profileDescription ?? "", height: geo.size.height, width: geo.size.width)
                        HStack {
                            // TODO: update to collects and visits
                            Text("\((viewModel.user?.createdMiraIds?.count ?? 0) + (viewModel.user?.collectedMiraIds?.count ?? 0))")
                                .foregroundColor(.white)
                                .font(.body1)

                            Text("collects + visits")
                                .foregroundColor(.gray)
                                .font(.body1)
                            Spacer()
                        }
                        .padding(.leading, 10)
                        if viewModel.user != nil || viewModel.hasLoadedProfile {
                            Group {
                                ZStack {
                                    MBSMapView(viewModel: mapViewModel, selectedMira: $selectedMira, showCollectedByList: $showCollectedByList, user: viewModel.user)
                                    
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Button {
                                                presentationMode.wrappedValue.dismiss()
                                            } label: {
                                                Images.goHome32.swiftUIImage
                                            }
                                            .padding(.trailing, 30)
                                        }
                                    }
                                    .padding(.bottom, 50)
                                }
                            }
                            .padding(.top, 5)
                        } else {
                            Spacer()
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            debugPrint("Button go to Home")
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Images.arrowB24.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                                debugPrint("Button go to Settings")
                                goToSettings = true
                        } label: {
                                Images.settings24.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                        }
                    }
                }
                .background(Colors.black.swiftUIColor)
                .navigationDestination(isPresented: $goToSettings) {
                    if let user = stateManager.loggedInUser {
                        NavigationRoute.settings(user: user).screen
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .accentColor(Colors.white.swiftUIColor)
        }
        .sheet(isPresented: $showCollectedByList) {
            NavigationRoute.miraCollectedByUsersList(mira: $selectedMira) { selectedUser in
                self.selectedUserOnMapId = selectedUser?.id
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                    gotoAotherUserProfile = true
                }

            }.screen
                .presentationDetents([.medium, .large])
        }
        .fullScreenCover(isPresented: $gotoAotherUserProfile) {
            NavigationRoute.profile(userId: selectedUserOnMapId ?? UUID()).screen
        }
        .onChange(of: selectedUserOnMapId) { newId in
                showCollectedByList = false
        }
        .background(Colors.black.swiftUIColor)

    }
}
