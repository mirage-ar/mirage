//
//  SentRequestsListView.swift
//  Mirage
//
//  Created by Saad on 14/11/2023.
//

import SwiftUI

struct SentRequestsListView: View {
    let viewModel: MyFriendsListViewModel
    @State var gotoUserProfile = false
    @State var selectedUserId: UUID?

    init(user: User) {
        self.viewModel = MyFriendsListViewModel(user: user)
    }

    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    Section {
                        sentRequestsListView()
                    }
                }
                .scrollContentBackground(.hidden)
                .padding([.leading, .trailing], -25)

                Spacer()
            }
        }
        .navigationTitle("SENT REQUESTS")
        .background(Colors.black.swiftUIColor)
        .fullScreenCover(isPresented: $gotoUserProfile) {
            NavigationRoute.profile(userId: self.selectedUserId ?? UUID()).screen
        }
        .onChange(of: selectedUserId) { newId in
        }
        .preference(key: ProfilePreferenceKey.self, value: viewModel.updatingFriendship)



    }
    func sentRequestsListView() -> some View {
        ForEach(viewModel.user.sentRequests ?? [], id: \.self) { user in
            UserFriendRowView(user: user, buttonTitles: ["-"], action: { action, user in
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
}
