//
//  MyFriendsListViewModel.swift
//  Mirage
//
//  Created by Saad on 14/11/2023.
//

import Foundation
import Combine


final class MyFriendsListViewModel: UserFriendsListViewModel {
    private var searchQueryCancellable: AnyCancellable?
    @Published var suggestedUsers: [User]?

    override func refreshSegmentTitles() {
        let friends = "\((user.friends?.count ?? 0)) FRIENDS"
        let requests = "\((user.pendingRequests?.count ?? 0)) REQUESTS"
        self.segments = [friends, requests, "SUGGESTIONS"]
    }
    override func searchFriends(searchText: String?) {
        searchQueryCancellable?.cancel() //cancel previous
        guard let searchText = searchText else { return }
        isSearchingUsers = true
        searchQueryCancellable = friendsApolloRepository.searchUsers(userName: searchText, phoneNumber: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { users in
                self.searchedUsers = users
                self.isSearchingUsers = false
            })
    }
    
    override func finishSearching() {
        self.isSearchingUsers = false
//        searchQueryCancellable?.cancel()
    }
    
    deinit {
//        searchQueryCancellable?.cancel()
//        searchQueryCancellable = nil
    }
}
