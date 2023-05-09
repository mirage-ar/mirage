//
//  User.swift
//  Mirage
//
//  Created by Saad on 05/05/2023.
//

import Foundation

struct User {
    let id: String
    let profileImage: String
    let profileImageDesaturated: String
    let userName: String

//    init(id: String, profileImage: String, profileImageDesaturated: String, userName: String) {
//        self.id = id
//        self.profileImage = profileImage
//        self.profileImageDesaturated = profileImageDesaturated
//        self.userName = userName
//    }
//    init(creator: MirageAPI.GetMirasQuery.Data.GetMira.Creator?) {
//        
//        id = creator?.id ?? "0"
//        profileImage = creator?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
//        userName = creator?.username ?? ""
//        profileImageDesaturated = creator?.profileImageDesaturated ?? blackImages[Int.random(in: 0..<blackImages.count)]
//    }

}
