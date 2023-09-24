//  StateManager.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 3/28/23.
//

import SwiftUI
import Combine

final class StateManager: ObservableObject {
    @Published var loggedInUser: User?
    @Published var selectedUserOnMap: User?
    @Published var isLoadingUserProfile = false
    @Published var isScreenRecording = false
    
    private var miraAddedNetworkSubscription: AnyCancellable?
    private let miraAddedSubject = PassthroughSubject<Mira?, Never>()
    public lazy var miraAddedPublisher = miraAddedSubject.eraseToAnyPublisher()
    let apolloRepository = AppConfiguration.shared.apollo
    let mapApolloRepository: MapApolloRepository = AppConfiguration.shared.apollo

    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo
    
    init() {
        if LocationManager.shared.location == nil {
            LocationManager.shared.requestLocation()
        }
        if AppConfiguration.shared.authentication {
//            subscribeToMiraAddChange()
        }
        
        loadCurrentUser()
    }
    
    func loadSelectedUser(id: String?) {
        userProfileRepository.getUser(id: id)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.loggedInUser = user
                UserDefaultsStorage().save(user)
                print("userProfileRepository.getUser, userId: \(user.id)")
                print(user.collectedMiraCount)
            } receiveError: { error in
                print("Get profile user error \(error)")
            }
    }
    
    func loadCurrentUser() {
        // TODO: update to own repository
        userProfileRepository.getUser(id: UserDefaultsStorage().getString(for: .userId) ?? "")
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.loggedInUser = user
                UserDefaultsStorage().save(user)
                print("userProfileRepository.getUser, userId: \(user.id)")
                print(user.collectedMiraCount)
            } receiveError: { error in
                print("Get profile user error \(error)")
            }
    }
    
    func updateLoggedInUser(user: User) {
        DispatchQueue.main.async {
            self.loggedInUser = user
        }
        UserDefaultsStorage().save(user)
    }
    
    func updateMapSelectedUser(user: User) {
        DispatchQueue.main.async {
            self.selectedUserOnMap = user
        }
    }
}

//MARK:- User Profile Methods
extension StateManager {
    func uploadUserImage(_ image: UIImage) {
        DownloadManager.shared.upload(image: image) { [weak self] url in
            if let url = url, var user = UserDefaultsStorage().getUser() {
                user.profileImage = url
                self?.update(user: user)
                self?.updateLoggedInUser(user: user)
                self?.updateMapSelectedUser(user: user)
            }
        }
    }

    func update(user: User) {
        userProfileRepository.updateUser(user: user)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                UserDefaultsStorage().save(user)
            } receiveError: { error in
                print("UpdateUser profileimage error \(error)" )
            }
    }

}
//MARK:- Subscriptions
extension StateManager {
    public func subscribeToMiraAddChange() {
        miraAddedNetworkSubscription = mapApolloRepository.subscribeToMiraAddChange()
            .sink(receiveValue: { [weak self] mira in
                debugPrint("miraadded \(mira)")
                self?.publishMiraChange(mira: mira)
            })
    }
    func publishMiraChange(mira: Mira?) {
        guard let mira = mira else { return }
        miraAddedSubject.send(mira)
    }
    func handleUpdateAuth(isLoggedIn: Bool = false) {
        if isLoggedIn {
            self.subscribeToMiraAddChange()
        } else {
            apolloRepository.cancelAllSubscriptions()
            apolloRepository.handleTokenUpdate(nil)
            miraAddedNetworkSubscription?.cancel()
            miraAddedNetworkSubscription = nil
        }
    }


}
