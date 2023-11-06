//
//  UserProfileView.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var mapViewModel = MapViewModel()
    
    @ObservedObject private var viewModel: UserProfileViewModel
    @State var showCollectedByList = false
    @State var gotoAotherUserProfile = false
    @State var selectedMira: Mira?
    @State var selectedUserOnMapId: UUID?
    @State var showMoreActionSheet = false
    
    init(userId: UUID) {
        viewModel = UserProfileViewModel(userId: userId)
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    VStack {
                        
                        ProfileInfoView(imageUrl: viewModel.user?.profileImage ?? "", userName: viewModel.user?.userName ?? "", profileDescription: viewModel.user?.profileDescription ?? "", height: geo.size.height, width: geo.size.width)
                        HStack {
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
                            debugPrint("more Button profile")
                            showMoreActionSheet = true
                        } label: {
                            Images.more24.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                .background(Colors.black.swiftUIColor)
                .edgesIgnoringSafeArea(.all)
            }
            .accentColor(Colors.white.swiftUIColor)
        }
        .sheet(isPresented: $showCollectedByList) {
            NavigationRoute.miraCollectedByUsersList(mira: $selectedMira) { selectedUser in
                let id = selectedUser?.id
                self.selectedUserOnMapId = id
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                    gotoAotherUserProfile = true
                }
            }.screen
                .presentationDetents([.medium, .large])

        }
        .confirmationDialog("", isPresented: $showMoreActionSheet, actions: {
            Button("Add as Friend") {
                if let id = self.viewModel.user?.id {
                    viewModel.sendFriendRequest(userId: id)
                }
            }
        })
        .fullScreenCover(isPresented: $gotoAotherUserProfile) {
            NavigationRoute.profile(userId: self.selectedUserOnMapId ?? UUID()).screen
        }
        .onChange(of: selectedUserOnMapId) { newId in
                showCollectedByList = false
        }
        .background(Colors.black.swiftUIColor)
    }
}
