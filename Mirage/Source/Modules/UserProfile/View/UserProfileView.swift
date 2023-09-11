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
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    VStack {
                        ProfileInfo(imageUri: stateManager.selectedUserOnMap?.profileImage ?? "", userName: stateManager.selectedUserOnMap?.userName ?? "", profileDescription: stateManager.selectedUserOnMap?.profileDescription ?? "", height: geo.size.height, width: geo.size.width)

                        HStack {
                            // TODO: update to collects and visits
                            Text("\((stateManager.selectedUserOnMap?.createdMiraIds?.count ?? 0) + (stateManager.selectedUserOnMap?.collectedMiraIds?.count ?? 0))")
                                .foregroundColor(.white)
                                .font(.body1)

                            Text("collects + visits")
                                .foregroundColor(.gray)
                                .font(.body1)
                            Spacer()
                        }
                        .padding(.leading, 10)

                        Group {
                            ZStack {
                                MBMapView(selectedMira: $selectedMira, showCollectedByList: $showCollectedByList, isProfile: true)

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
}

struct ProfileInfo: View {
    let imageUri: String
    let userName: String
    let profileDescription: String
    let height: Double
    let width: Double
    
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        // PROFILE INFO
        ZStack(alignment: .bottom) {
            VStack {
                AsyncImage(url: URL(string: imageUri)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: width,
                            height: dragOffset > 0 ? (height / 2) + dragOffset : (height / 2)
                        )
                        .clipped()
                        .offset(y: dragOffset > 0 ? -dragOffset / 2 : 0.0)
                } placeholder: {
                    ProgressView()
                        .foregroundColor(Colors.white8p.swiftUIColor)
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: 350, alignment: .top)
            .clipped()

            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Spacer()
                    Group {
                        Text(userName)
                            .font(.h2)
                            .textCase(.uppercase)
                            .lineLimit(2)
                        Text(profileDescription)
                            .font(.body1)
                    }
                    .foregroundColor(Colors.white.swiftUIColor)
                }
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 150)
            .background(
                LinearGradient(gradient: Gradient(colors: [Colors.black.swiftUIColor, .clear]), startPoint: .bottom, endPoint: .top)
            )
            .gesture(
                DragGesture().onChanged { value in
                    if value.startLocation.y < height, value.translation.height > 0 {
                        dragOffset = value.translation.height
                    }

                    print("DRAG")
                }
                .onEnded { _ in
                    withAnimation {
                        dragOffset = 0
                    }
                }
            )
        }
        .background(Colors.black.swiftUIColor)
    }
}
