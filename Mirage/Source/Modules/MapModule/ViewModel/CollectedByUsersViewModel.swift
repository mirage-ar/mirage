//
//  CollectedByUsersViewModel.swift
//  Mirage
//
//  Created by Saad on 21/06/2023.
//

import Foundation

final class CollectedByUsersViewModel: ObservableObject {
    @Published var usersList: [User]?
    
    init(mira: Mira) {
//        selectedMira = mira
        getCollectedByList()
    }

    func getCollectedByList() {
        
    }

}
