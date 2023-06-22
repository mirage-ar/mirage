//
//  UserListRow.swift
//  Mirage
//
//  Created by Saad on 22/06/2023.
//

import SwiftUI

struct UserListRow: View {
    let iconSize = 48.0
    let user: User
    var body: some View {
        ZStack {
            HStack {
                AsyncImage(url: URL(string: user.profileImage)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: iconSize, height: iconSize)
                    .background(Colors.g3Grey.just)
                    .clipShape(Circle())
                Text(user.userName ?? "NnA")
                    .font(.body2)
                Spacer()
                Images.collectMiraGreen.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
       
    }
}
