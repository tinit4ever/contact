//
//  NotificationName.swift
//  Contact
//
//  Created by tinit on 31/10/2023.
//

import Foundation

import NotificationCenter

extension Notification.Name {
    static let addNewContact = Notification.Name("addNewContact")
    static let deleteContact = Notification.Name("deleteContact")
    static let updateContact = Notification.Name("updateContact")
}
