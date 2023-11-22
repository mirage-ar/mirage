//
//  UserFriendRowView.swift
//  Mirage
//
//  Created by Saad on 14/11/2023.
//

import SwiftUI

struct UserFriendRowView: View {
    let user: User
    let imageSize = 48.0
    var action: (String, User) -> Void

    var body: some View {
        
        GeometryReader { geo in
                HStack {
                    AsyncImage(url: URL(string: user.profileImage)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: imageSize, height: imageSize)
                    .background(Colors.g3Grey.just)
                    .clipShape(Circle())
                    .border(user.friendshipStatus == .accepted ? .green : .clear)
                    
                    Text(user.userName ?? "USER_NAN")
                        .font(.body1)
                        .foregroundColor(Colors.white.swiftUIColor)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    let buttonTitles = buttonTitles(status: user.friendshipStatus)
                    ForEach(buttonTitles, id: \.self) { title in
                        Button(title) {
                            action(title, self.user)
                        }
                        .tint(Colors.g1DarkGrey.swiftUIColor)
                        .controlSize(.small) // .large, .medium or .small
                        .buttonStyle(.borderedProminent)
                        
                    }
                    
                                
                }
                .contentShape(Rectangle())
        }
    }
    func buttonTitles(status: FriendshipStatus) -> [String] {
        let isCurrentFriend = UserDefaultsStorage().getUser()?.friends?.contains(self.user)
        if isCurrentFriend == true {
            return ["UNFRIEND"]
        }
        switch status {
        case .accepted:
            return ["UNFRIEND"]
            
        case .none:
            return ["ADD +"]

        case .pending:
            return ["ACCEPT", "-"]

        case .requested:
            return ["-"]

        case .rejected:
            return ["ADD +"]

        }
    }
}

