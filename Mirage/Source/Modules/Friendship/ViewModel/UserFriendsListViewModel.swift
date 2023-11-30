//
//  UserFriendsListViewModel.swift
//  Mirage
//
//  Created by Saad on 13/11/2023.
//

import Foundation
//Other User Friendslist

class UserFriendsListViewModel: ObservableObject {
    var user: User
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo
    let friendsApolloRepository: FriendsApolloRepository = AppConfiguration.shared.apollo
    
    @Published var segments: [String] = []
    @Published var updatingFriendship: Bool = false
    
    @Published var searchedUsers: [User]?
    @Published var mutalFriends: [User]?
    @Published var filteredMutalFriends: [User]?
    @Published var isSearchingUsers = false

    init(user: User) {
        self.user = user
        self.loadMutualFriends()
        refreshSegmentTitles()
    }
    
    func refreshSegmentTitles() {
        let friends = "\((user.friends?.count ?? 0)) FRIENDS"
        let mutual = "\((mutalFriends?.count ?? 0)) MUTUAL"
        self.segments = [friends, mutual]
    }
    
    func loadProfile() {
        userProfileRepository.getUser(id: self.user.id.uuidString)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.user = user
                self.updatingFriendship = false
                self.loadMutualFriends()
            } receiveError: { error in
                print("Get profile user error \(error)" )
            }
    }
    func updateFriendshipAgainstAction(_ action: String, userId: UUID) {
        updatingFriendship = true
        let status = statusForActoin(action)
        if status == .requested {
            friendsApolloRepository.sendFriendRequest(userId: userId)
                .receiveAndCancel { status in
                    self.loadProfile()
                    debugPrint("friendsApolloRepository.updateFriendship, userId: \(userId)")
                } receiveError: { error in
                    print("sendFriendRequest Request Failed \(error)" )
                    self.updatingFriendship = false

                }
        } else {
            friendsApolloRepository.updateFriendRequest(userId: userId, status: status)
                .receiveAndCancel { status in
                    self.loadProfile()
                    debugPrint("friendsApolloRepository.updateFriendship, userId: \(userId)")
                } receiveError: { error in
                    print("updateFriendship Request Failed \(error)" )
                    self.updatingFriendship = false

                }
        }
    }
    func searchFriends(searchText: String?) {
        filterFriends(searchText: searchText)
    }
    func filterFriends(searchText: String?) {
        if searchText == nil || searchText?.isEmpty == true {
            searchedUsers = user.friends
            filteredMutalFriends = mutalFriends
        }
    }
    func finishSearching() {
        self.isSearchingUsers = false
    }
    
    func loadMutualFriends() {
        if let myFriends = UserDefaultsStorage().getUser()?.friends {
            mutalFriends = user.friends?.filter(myFriends.contains)
        }
    }

    func statusForActoin(_ action: String) -> FriendshipStatus {
        switch action {
        case "ACCEPT":
            return .accepted
        case "-", "UFRIEND":
            return .rejected
        case "ADD +":
            return .requested
            
        default:
            return .none
        }
    }
    
}
