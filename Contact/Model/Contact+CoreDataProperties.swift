//
//  Contact+CoreDataProperties.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var mail: String?
    @NSManaged public var isMain: Bool

}

extension Contact : Identifiable {

}
