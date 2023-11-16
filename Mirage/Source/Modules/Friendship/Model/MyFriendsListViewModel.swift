//
//  MyFriendsListViewModel.swift
//  Mirage
//
//  Created by Saad on 14/11/2023.
//

import Foundation

final class MyFriendsListViewModel: UserFriendsListViewModel {
    
    override func refreshSegmentTitles() {
        let friends = "\((user.friends?.count ?? 0)) FRIENDS"
        let requests = "\((user.pendingRequests?.count ?? 0)) REQUESTS"
        self.segments = [friends, requests, "SUGGESTIONS"]
    }
}
