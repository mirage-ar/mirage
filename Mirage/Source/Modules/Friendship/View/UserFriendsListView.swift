//
//  UserFriendsListView.swift
//  Mirage
//
//  Created by Saad on 13/11/2023.
//

import SwiftUI

struct UserFriendsListView: View {
    let viewModel: UserFriendsListViewModel
    @State private var currentSegment: Int = 0
    @State var gotoUserProfile = false
    @State var selectedUserId: UUID?

    init(user: User) {
        self.viewModel = UserFriendsListViewModel(user: user)
        currentSegment = 0
    }
    var body: some View {
        
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                SegmentedView(segments: viewModel.segments, selected: $currentSegment) { index in
                    debugPrint("Index changed \(index)")
                }
                List {
                    Section {
                        switch currentSegment {
                        case ViewTag.friends.rawValue:
                            friendsListView()
//                        case ViewTag.mutalFriends.rawValue:
////                            mutualFriendListView()
                        default:
                            friendsListView()
                            
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .padding([.leading, .trailing], -25)
                
                Spacer()
            }
        }
        .navigationTitle(self.viewModel.user.userName ?? "")
        .background(Colors.black.swiftUIColor)
        .fullScreenCover(isPresented: $gotoUserProfile) {
            NavigationRoute.profile(userId: self.selectedUserId ?? UUID()).screen
        }
        .onChange(of: selectedUserId) { newId in
        }
        .preference(key: ProfilePreferenceKey.self, value: viewModel.updatingFriendship)



    }
    
    func friendsListView() -> some View {
        ForEach(viewModel.user.friends ?? [], id: \.self) { user in
            UserFriendRowView(user: user, action: { action, user in
                viewModel.updateFriendshipAgainstAction(action, userId: user.id)
            })
            .listRowBackground(Color.clear)
            .onTapGesture {
                self.selectedUserId = user.id
                self.gotoUserProfile = true
                
                debugPrint("show Userprofile tapped \(user)")
            }
            .frame(height: 55)
        }
    }
    
    func mutualFriendListView() -> some View {
        ForEach(viewModel.mutalFriends ?? [], id: \.self) { user in
            UserFriendRowView(user: user, action: { action, user in
                viewModel.updateFriendshipAgainstAction(action, userId: user.id)
            })
            .listRowBackground(Color.clear)
            .onTapGesture {
                self.selectedUserId = user.id
                self.gotoUserProfile = true
                
                debugPrint("show Userprofile tapped \(user)")
            }
            .frame(height: 55)
        }
    }
    
    enum ViewTag: Int {
        case friends = 0, mutalFriends
    }

}

