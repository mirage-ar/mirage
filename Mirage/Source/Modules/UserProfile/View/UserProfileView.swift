//
//  UserProfileView.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var stateManager: StateManager
    @Environment(\.presentationMode) var presentationMode

    @State var goToSettings = false
    @State var goToHome = false

    @State var showCollectedByList = false
    @State var selectedMira: Mira?

    @ObservedObject private var viewModel: UserProfileViewModel

    var ownProfile = true
    let userId: String

    init(userId: String) {
        self.userId = userId
        ownProfile = UserDefaultsStorage().getString(for: .userId)?.uppercased() == userId.uppercased()
        viewModel = UserProfileViewModel(userId: userId)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack(alignment: .bottom) {
                        VStack {
                            ZStack {
                                AsyncImage(url: URL(string: stateManager.selectedUserOnMap?.profileImage ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                        .foregroundColor(.white)
                                }
                                if ownProfile && stateManager.isLoadingUserProfile {
                                    ProgressView()
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 350, alignment: .top)
                        .clipped()

                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Spacer()
                                Group {
                                    Text(stateManager.selectedUserOnMap?.userName ?? "___")
                                        .font(.h2)
                                        .textCase(.uppercase)
                                        .lineLimit(2)
                                    // TODO: clean up
                                    if ownProfile, let selectedUser = stateManager.selectedUserOnMap, selectedUser.isDescriptionEmpty {
                                        Button {
                                            goToSettings = true

                                        } label: {
                                            Text("EDIT PROFILE")
                                                .font(.subtitle1)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .background(Colors.white.swiftUIColor)
                                        .foregroundColor(Colors.black.swiftUIColor)
                                        .cornerRadius(10)
                                        .frame(width: 150)
//                                        .hiddenConditionally(isHidden: stateManager.currentUser!.isDescriptionEmpty)

                                    } else {
                                        Text(stateManager.selectedUserOnMap?.profileDescription ?? "")
                                            .font(.body)
                                    }
                                }
                                .foregroundColor(Colors.white.swiftUIColor)
                            }
                            Spacer()
                        }
                        .padding([.leading, .trailing], 10)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Colors.black.swiftUIColor, .clear]), startPoint: .bottom, endPoint: .top)
                        )
                        .frame(maxHeight: 150)
                    }
                    .background(Colors.black.swiftUIColor)
                    
                    Group {
                        HStack {
                            Text("\((stateManager.selectedUserOnMap?.createdMiraIds?.count ?? 0) + (stateManager.selectedUserOnMap?.collectedMiraIds?.count ?? 0))")
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            Text("collects + visits")
                                .foregroundColor(.gray)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.leading, 10)
                        ZStack {
                            MBMapView(selectedMira: $selectedMira, showCollectedByList: $showCollectedByList, isProfile: true)
                                .clipped()
                            
                            
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
                        if ownProfile {
                            debugPrint("Button go to Settings")
                            goToSettings = true
                        } else {
                            debugPrint("more Button profile")
                        }
                    } label: {
                        if ownProfile {
                            Images.settings24.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        } else {
                            Images.more24.swiftUIImage
                                .resizable()
                                .scaledToFit()
                        }
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
        .onAppear {
            stateManager.selectedUserOnMap = viewModel.user
        }
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Here I'm just assuming that StateManager and UserProfileViewModel have default initialisers
//        // Replace this with actual initialisation of these objects
//        let stateManager = StateManager()
//        let userId = "d240958e-7aaa-4cf8-870d-d8fb5b078f8a"
//        UserProfileView(userId: userId)
//            .environmentObject(stateManager)
//    }
//}
