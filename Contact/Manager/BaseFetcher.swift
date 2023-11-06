//
//  BaseFetcher.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import Foundation
import Combine

struct APIPath {
    static let getContact: String = "/get-contact"
}

class BaseFetcher {
    
//  Fetch from normally APICaller
//    func getContact(completion: @escaping (Result<[APIContact], Error>) -> Void)  {
//        APICaller.shared.requestAPI(url: APIPath.getContact, responseType: [APIContact].self) { result in
//            switch result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }

// Fetch from Combine APICaller
    func getContact() -> AnyPublisher<[APIContact], Error> {
        return APICaller.shared.requestAPI(url: APIPath.getContact, responseType: [APIContact].self)
    }
}
