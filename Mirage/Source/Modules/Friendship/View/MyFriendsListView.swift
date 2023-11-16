//
//  MyFriendsListView.swift
//  Mirage
//
//  Created by Saad on 13/11/2023.
//

import SwiftUI

struct MyFriendsListView: View {
    let viewModel: MyFriendsListViewModel
    @State private var currentSegment: Int = 0
    @State private var showSentRequests: Bool = false
    @State var gotoUserProfile = false
    @State var selectedUserId: UUID?

    init(user: User) {
        self.viewModel = MyFriendsListViewModel(user: user)
        currentSegment = ViewTag.friends.rawValue
    }
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                SegmentedView(segments: viewModel.segments, selected: $currentSegment)
                HStack {
                    Spacer()
                    Button {
                        self.showSentRequests = true
                    } label: {
                        Text("SENT")
                            .font(.body2)
                            .foregroundColor(Colors.green.swiftUIColor)
                    }
                }
                .padding([.leading, .trailing], 20)
                List {
                    Section {
                        switch currentSegment {
                        case ViewTag.friends.rawValue:
                            friendsListView()
                        case ViewTag.requests.rawValue:
                            requestsListView()
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
        .navigationDestination(isPresented: $showSentRequests) {
            NavigationRoute.sentRequestsView(user: viewModel.user).screen
        }
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
            UserFriendRowView(user: user, buttonTitles: ["UNFRIEND"], action: { action, user in
                viewModel.updateFriendRequestAgainstAction(action, userId: user.id)
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
    
    func requestsListView() -> some View {
        ForEach(viewModel.user.pendingRequests ?? [], id: \.self) { user in
            UserFriendRowView(user: user, buttonTitles: ["ACCEPT", "-"], action: { action, user in
                viewModel.updateFriendRequestAgainstAction(action, userId: user.id)
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
        case friends = 0, requests, suggestions
    }
}

