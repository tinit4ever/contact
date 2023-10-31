//
//  Contact.swift
//  Contact
//
//  Created by tinit on 30/10/2023.


import Foundation

public struct APIContact: Codable {
    let name: String
    let mail: String
    let phoneNumber: String
    let isMain: Bool
}
