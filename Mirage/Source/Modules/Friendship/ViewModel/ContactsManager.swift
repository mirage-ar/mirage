//
//  ContactsManager.swift
//  Mirage
//
//  Created by Saad on 27/11/2023.
//

import Foundation
import Contacts

class ContactsManager {
    
    var fetchHandler: (([String]?) -> ())?
    func isContactPermissionGranted() -> Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            return false
        }
        return true
    }
    func fetchContacts(handler: @escaping ([String]?) -> Void) {
        
        if !isContactPermissionGranted() {
            handler(nil)
        } else {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            self.fetchHandler = handler
            if status == .notDetermined {
                requestAccessAndFetchContacts()
            } else {
                loadContactNumbers()
            }
        }
    }
    private func loadContactNumbers() {
        DispatchQueue.global(qos: .background).async {
            let keysToFetch = [CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            
            fetchRequest.mutableObjects = false
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            do {
                try CNContactStore().enumerateContacts(with: fetchRequest, usingBlock: { contact, stop in
                    contacts.append(contact)
                })
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            var numbers = [String]()
            for contact in contacts {
                for phoneNo in contact.phoneNumbers {
                    numbers.append(phoneNo.value.stringValue.convertedDigitsToLocale(Locale(identifier: "EN")))
                }
            }
            self.fetchHandler?(numbers)
        }
    }
    func requestAccessAndFetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if granted == true {
               self?.loadContactNumbers()
            }
        }
        
    }
}
