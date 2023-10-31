//
//  ContactViewModel.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import Foundation
import CoreData
import UIKit

protocol ContactViewModelProtocol {
    func addContact(name: String, mail: String, phoneNumber: String)
    func importContact(completion: @escaping () -> Void)
    func getContact()
    func deleteContact(contact: Contact)
    var contacts: [Contact] {get set}
    var sections: [[Contact]] {get set}
}

class ContactViewModel {
    let baseFetcher: BaseFetcher?
    var contacts: [Contact] = []
    var sections: [[Contact]] = [[]]
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Contact")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()
    
    init(baseFetcher: BaseFetcher) {
        self.baseFetcher = baseFetcher
    }
}

extension ContactViewModel: ContactViewModelProtocol {
    
    func addContact(name: String, mail: String, phoneNumber: String) {
        let context = persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
        contact.name = name
        contact.mail = mail
        contact.phoneNumber = phoneNumber
        do {
            try context.save()
            NotificationCenter.default.post(name: .addNewContact,object: nil)
        } catch {
            print("Error checking or saving contacts: \(error)")
        }
    }
    func deleteContact(contact: Contact) {
        let context = persistentContainer.viewContext
        do {
            context.delete(contact)
            try context.save()
            NotificationCenter.default.post(name: .deleteContact, object: nil)
        } catch let deleteError {
            print("Failde to delete \(deleteError)")
        }
    }
    
    func importContact(completion: @escaping () -> Void) {
        baseFetcher?.getContact(completion: { result in
            switch result {
            case .success(let data):
                self.importContactSuccess(data: data)
                completion()
            case .failure(let error):
                self.importContactFaild(error: error)
            }
        })
    }
    
    private func importContactSuccess(data: [APIContact]) {
        // Import data to CoreData Contact
        data.forEach { apiContact in
            let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
            let context = persistentContainer.viewContext
            
            do {
                let contactCount = try context.count(for: fetchRequest)
                
                if contactCount == 0 {
                    // Import data to CoreData Contact only if it's empty
                    data.forEach { apiContact in
                        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
                        contact.name = apiContact.name
                        contact.phoneNumber = apiContact.phoneNumber
                        contact.mail = apiContact.mail
                        contact.isMain = apiContact.isMain
                    }
                    // Save the changes
                    try context.save()
                }
            } catch {
                print("Error checking or saving contacts: \(error)")
            }
        }
        
    }
    
    private func importContactFaild(error: Error) {
        print("ERROR")
    }
    
    internal func getContact() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
        do {
            contacts.removeAll()
            sections.removeAll()
            contacts = try context.fetch(fetchRequest)
            
            var mainContact: Contact?
            if let index = contacts.firstIndex(where: { $0.isMain } ) {
                mainContact = contacts.remove(at: index)
            }
            
            let sortedContacts = contacts.sorted {
                $0.name! < $1.name!
            }
            
            if let mainContact = mainContact {
                sections.append([mainContact])
            }
            
            for contact in sortedContacts {
                
                if let firstCharacter = contact.name!.first {
                    if let index = sections.firstIndex(where: {
                        $0.first?.name!.first == firstCharacter && $0.first?.isMain == false
                    }) {
                        sections[index].append(contact)
                    } else {
                        sections.append([contact])
                    }
                }
            }
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }
    
}
