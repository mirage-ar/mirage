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
    @State var gotoFriends = false
    @State var showFriendshipAlert = false
    @State private var needsUserRefresh: Bool = false

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
//                                guard viewModel.user != nil else { return }
                                self.gotoFriends = true
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
                            
                            friendshipButton()
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
                .navigationDestination(isPresented: $gotoFriends) {
                    //TODO: fix the default user value here
                    NavigationRoute.friendsListView(user: viewModel.user ?? User()).screen
                }
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
            Button("Cancel") {
            }
        })
        .alert(friendshipAlertTitle(userName: self.viewModel.user?.userName ?? ""), isPresented: $showFriendshipAlert, actions: {
            Button("Cancel", role: .cancel) { }
            if viewModel.user?.friendshipStatus == .pending {
                Button(friendshipAlertButtonTitle, role: .cancel) {
                    if let id = self.viewModel.user?.id {
                        viewModel.updateFriendship(targetStatus: .accepted, userId: id)
                    }
                }
            }
            Button(friendshipAlertButtonTitle, role: .destructive) {
                if let id = self.viewModel.user?.id, let status =  self.viewModel.user?.friendshipStatus{
                    viewModel.updateFriendship(targetStatus: targetStatus(status), userId: id)
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
        .onPreferenceChange(ProfilePreferenceKey.self) { (value: ProfilePreferenceKey.Value) in
            needsUserRefresh = !value
            if value == false && needsUserRefresh {
                self.viewModel.refreshProfile()
            }
            print(needsUserRefresh)  // Prints: "New value! 🤓"
        }
    }
    
    func friendshipButton() -> some View {
        var title = "ADD +"
        switch viewModel.user?.friendshipStatus ?? .none {
        case .accepted:
            title = "UNFRIEND"
        case .none:
            title = "ADD +"

        case .pending:
            title = "ACCEPT"
        case .requested:
            title = "PENDING"
        case .rejected:
            title = "ADD +"

        }
        let tint = (viewModel.user?.friendshipStatus == FriendshipStatus.none || viewModel.user?.friendshipStatus == .rejected) ? Colors.white.swiftUIColor : Colors.g1DarkGrey.swiftUIColor
        let foreground = (viewModel.user?.friendshipStatus == FriendshipStatus.none || viewModel.user?.friendshipStatus == .rejected) ? Colors.black.swiftUIColor : Colors.white.swiftUIColor
        return Button {
            debugPrint("Add Friend button")
            guard let status = self.viewModel.user?.friendshipStatus else { return }
            if status  == .pending || status == .requested || status == .accepted{
                showFriendshipAlert = true
            } else {
                if let id = viewModel.user?.id {
                    viewModel.updateFriendship(targetStatus: .requested, userId: id)
                }
            }

        } label: {
            if viewModel.updatingFriendship {
                ActivityIndicator(color: Colors.green.swiftUIColor, size: 20)
            } else {
                Text(title)
            }
        }
        .tint(tint)
        .foregroundColor(foreground)
        .controlSize(.small)
        .buttonStyle(.borderedProminent)
        
    }
    var friendshipAlertButtonTitle: String {
        var title = ""
        switch viewModel.user?.friendshipStatus ?? .none {
        case .accepted:
            title = "UNFRIEND"
        case .pending:
            title = "DELETE"
        case .requested:
            title = "DELETE"
        default:
           title = ""
        }
        return title
    }
    func friendshipAlertTitle(userName:String) -> String {
        var title = ""
        switch viewModel.user?.friendshipStatus ?? .none {
        case .accepted:
            title = "Unfriend \(userName)?"
        case .pending:
            title = "Decline friend request?"
        case .requested:
            title = "Delete send friend request?"
        default:
           title = ""
        }
        return title
    }
    func friendshipAlertMessage(userName:String) -> String {
        var title = "Add"
        switch viewModel.user?.friendshipStatus ?? .none {
        case .accepted:
            title = "Mirage won’t tell \(userName) that they have been unfriended by you"
        case .pending:
            title = "Mirage won’t tell \(userName) that their request is not accepted by you"
        case .requested:
            title = "\(userName) will not see your friend request anymore and will not be notified"
        default:
           title = "ADD"
        }
        return title
    }
    func targetStatus(_ status: FriendshipStatus) -> FriendshipStatus {
        if status == .accepted {
            return .rejected
        } else if status == .pending {
            return .rejected
        } else if status == .requested {
            return .rejected
        }
        return .none
    }

}

struct ProfilePreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
