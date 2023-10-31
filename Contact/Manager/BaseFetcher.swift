//
//  BaseFetcher.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import Foundation

struct APIPath {
    static let getContact: String = "/get-contact"
}

class BaseFetcher {
    
    func getContact(completion: @escaping (Result<[APIContact], Error>) -> Void)  {
        APICaller.shared.requestAPI(url: APIPath.getContact, responseType: [APIContact].self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
