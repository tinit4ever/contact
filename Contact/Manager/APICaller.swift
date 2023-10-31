//
//  APICaller.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import Foundation

struct Constants {
    static let baseURL = "https://f10d6019-5422-4471-93c8-0955f4daaeaa.mock.pstmn.io"
}

enum APIError: Error {
    case failedToGetData
}

class  APICaller {
    static let shared = APICaller()
    var name: String = ""
    private init() {}
    
    func requestAPI<T: Codable>(url: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + url) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        
        task.resume()
    }
        
}
