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
    @State var gotoFriends = false

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
                            HStack(spacing: 10) {
                                Text("\(viewModel.user?.friends?.count ?? 0)")
                                    .foregroundColor(.white)
                                    .font(.subtitle2)
                                    .lineLimit(1)

                                
                                Text("friends  ")
                                    .foregroundColor(.gray)
                                    .font(.body2)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .frame(width: geo.size.width * 0.3)
                            .onTapGesture {
                                guard viewModel.user != nil else { return }
                                gotoFriends = true
                            }
                            
                            HStack (spacing: 10) {
                                Text("\((viewModel.user?.createdMiraIds?.count ?? 0) + (viewModel.user?.collectedMiraIds?.count ?? 0))")
                                    .foregroundColor(.white)
                                    .font(.subtitle2)
                                    .lineLimit(1)
                                
                                Text("views & col")
                                    .foregroundColor(.gray)
                                    .font(.body2)
                                    .lineLimit(1)

                                Spacer()
                            }
                            .frame(width: geo.size.width * 0.4)

                            Spacer()
                            Button {
                                debugPrint("Settings button")
                                goToSettings = true
                            } label: {
                                Images.settings24.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)

                            }
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
                                debugPrint("Button more")
//                                goToSettings = true
                        } label: {
                                Images.more24.swiftUIImage
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
                .navigationDestination(isPresented: $gotoFriends) {
                    //TODO: fix the default user value here
                    NavigationRoute.friendsListView(user: viewModel.user ?? User()).screen
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
