//
//  MyFriendsListView.swift
//  Mirage
//
//  Created by Saad on 13/11/2023.
//

import SwiftUI
import Contacts

struct MyFriendsListView: View {
    let viewModel: MyFriendsListViewModel
    @State private var currentSegment: Int = 0
    @State private var showSentRequests: Bool = false
    @State var gotoUserProfile = false
    @State var selectedUserId: UUID?
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showContactsPermissinoAlert = false
    
    init(user: User) {
        viewModel = MyFriendsListViewModel(user: user)
        currentSegment = ViewTag.friends.rawValue
    }
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                SegmentedView(segments: viewModel.segments, selected: $currentSegment) { index in
                    if index == ViewTag.suggestions.rawValue {
                        if !ContactsManager().isContactPermissionGranted() {
                            showContactsPermissinoAlert = true
                        } else {
                            //Start loading contacts
                            viewModel.fetchFriendSuggestions()
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button {
                        self.showSentRequests = true
                    } label: {
                        Text("SENT")
                            .foregroundColor(Colors.green.swiftUIColor)
                            .font(.body2)
                    }
                }
                .padding([.leading, .trailing], 20)
                SearchBar(text: $searchText, onTextChanged: performSearch, onStateChanged: searchViewStateChanged)
                List {
                    
                    if hasData() {
                        Section {
                            switch currentSegment {
                            case ViewTag.friends.rawValue:
                                friendsListView()
                            case ViewTag.requests.rawValue:
                                requestsListView()
                            case ViewTag.suggestions.rawValue:
                                generalUsersList(list: viewModel.suggestedUsers ?? [])

                            default:
                                friendsListView()
                                
                            }
                        } header: {
                            Text(isSearching ? sectionTitle(): "")
                                .foregroundColor(Colors.g2MediumGrey.swiftUIColor)
                            Divider()
                                .overlay(Colors.g4LightGrey.swiftUIColor)
                            
                        }
                        .background(.black)
                        
                    }
                    if isSearching {
                        if viewModel.isSearchingUsers {
                            ActivityIndicator(color: Colors.green.swiftUIColor, size: 40)
                            
                        } else if (viewModel.searchedUsers?.count ?? 0) > 0 {
                            Section {
                                self.generalUsersList(list: viewModel.searchedUsers ?? [])
                            } header: {
                                Text("People you may know")
                                    .foregroundColor(Colors.g2MediumGrey.swiftUIColor)
                                Divider()
                                    .overlay(Colors.g4LightGrey.swiftUIColor)
                                
                            }
                            .background(.black)
                            
                        } else {
                            Text("No contacts found")
                                .font(.body1)
                        }
                        
                    }
                }
                .background(.black)
                .scrollContentBackground(.hidden)
                .padding([.leading, .trailing], -25)
                
                Spacer()
            }
            
        }
        .background(Colors.black.swiftUIColor)
        .navigationTitle(self.viewModel.user.userName ?? "")
        .navigationDestination(isPresented: $showSentRequests) {
            NavigationRoute.sentRequestsView(user: viewModel.user).screen
        }
        .fullScreenCover(isPresented: $gotoUserProfile) {
            NavigationRoute.profile(userId: self.selectedUserId ?? UUID()).screen
        }
        .onChange(of: selectedUserId) { newId in
            
        }
        .preference(key: ProfilePreferenceKey.self, value: viewModel.updatingFriendship)
        .alert(isPresented: $showContactsPermissinoAlert) {
            conactsPermissionAlert()
        }
        
    }
    func performSearch(searchText: String?) {
        viewModel.searchFriends(searchText: searchText)
    }
    func searchViewStateChanged(isEditing: Bool) {
        self.isSearching = isEditing
        if !isEditing {
            viewModel.finishSearching()
        }
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
    
    func requestsListView() -> some View {
        ForEach(viewModel.user.pendingRequests ?? [], id: \.self) { user in
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
    
    func generalUsersList(list: [User]) -> some View {
        ForEach(list, id: \.self) { user in
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
    func hasData() -> Bool {
        switch currentSegment {
        case ViewTag.friends.rawValue:
            return (viewModel.user.friends?.count ?? 0) > 0
        case ViewTag.requests.rawValue:
            return (viewModel.user.pendingRequests?.count ?? 0) > 0
        case ViewTag.suggestions.rawValue:
            return (viewModel.suggestedUsers?.count ?? 0) > 0
            
        default:
            return false
        }
    }
    func sectionTitle() -> String {
        switch currentSegment {
        case ViewTag.friends.rawValue:
            return "Your Contacts"
        case ViewTag.requests.rawValue:
            return "Pending Requests"
        case ViewTag.suggestions.rawValue:
            return "Suggestions"
            
        default:
            return ""
        }
    }
    
    func conactsPermissionAlert() -> Alert {
        return Alert(title: Text("Permission to Contacts"), message: Text("This app needs access to contacts in order to fetch existing users."), primaryButton: .default(
            Text("Settings"),
            action: {
                
            }
        ), secondaryButton: .destructive(
            Text("Cancel"),
            action: {
                
            })
        )
        
    }
    
    enum ViewTag: Int {
        case friends = 0, requests, suggestions
    }
}

