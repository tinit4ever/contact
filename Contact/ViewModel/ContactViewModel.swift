//
//  ContactViewModel.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import Foundation
import CoreData
import Combine

protocol ContactViewModelProtocol {
    func addContact(name: String, mail: String, phoneNumber: String)
    func updateContact(oldName: String, newName: String, newMail: String, newPhoneNumber: String)
    //ImportContact
    //    func importContact(completion: @escaping () -> Void)
    // Combine ImportContact
    func importContact()
    func swapContacts(_ sourceContact: Contact,_ destinationContact: Contact)
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
    private var cancellabels: Set<AnyCancellable> = []
    
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
        contact.isMain = false
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
    
    func updateContact(oldName: String, newName: String, newMail: String, newPhoneNumber: String) {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "name == %@", oldName)
        
        do {
            let existingContacts = try context.fetch(fetchRequest)
            
            if let contact = existingContacts.first {
                contact.name = newName
                contact.mail = newMail
                contact.phoneNumber = newPhoneNumber
                try context.save()
                NotificationCenter.default.post(name: .updateContact, object: nil, userInfo: ["updatedContact": contact])
            } else {
                print("Contact with name \(oldName) not found.")
            }
        } catch {
            print("Error updating contact: \(error)")
        }
    }
    
    // Normally importContact
    //    func importContact(completion: @escaping () -> Void) {
    //        baseFetcher?.getContact(completion: { result in
    //            switch result {
    //            case .success(let data):
    //                self.importContactSuccess(data: data)
    //                completion()
    //            case .failure(let error):
    //                self.importContactFaild(error: error)
    //            }
    //        })
    //    }
    
    // Combine importContact
    func importContact() {
        baseFetcher?.getContact()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.importContactFaild(error: error)
                }
            },
                  receiveValue: { [weak self] data in
                self?.importContactSuccess(data: data)
            })
            .store(in: &cancellabels)
    }
    func swapContacts(_ sourceContact: Contact, _ destinationContact: Contact) {
        let context = persistentContainer.viewContext
        let tempName = sourceContact.name
        sourceContact.name = destinationContact.name
        destinationContact.name = tempName
        
        do {
            try context.save()
        } catch {
            print("Error while saving: \(error)")
        }
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
                $0.name!.lowercased() < $1.name!.lowercased()
            }
            
            //            let sortedContacts = contacts
            
            if let mainContact = mainContact {
                sections.append([mainContact])
            }
            
            for contact in sortedContacts {
                if let firstCharacter = contact.name!.lowercased().first {
                    if let index = sections.firstIndex(where: {
                        $0.first?.name!.lowercased().first == firstCharacter && $0.first?.isMain == false
                    }) {
                        sections[index].append(contact)
                    } else {
                        sections.append([contact])
                    }
                }
            }
            print("getContact")
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }
    
}
