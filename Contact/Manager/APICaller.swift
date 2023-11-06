//
//  APICaller.swift
//  Contact
//
//  Created by tinit on 30/10/2023.
//

import Foundation
import Combine

struct Constants {
    static let baseURL = "https://f10d6019-5422-4471-93c8-0955f4daaeaa.mock.pstmn.io"
}

enum APIError: Error {
    case failedToGetData
}

// Normally APICaller
//class  APICaller {
//    static let shared = APICaller()
//    var name: String = ""
//    private init() {}
//
//    func requestAPI<T: Codable>(url: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: Constants.baseURL + url) else { return }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            do {
//                let results = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(results))
//            } catch {
//                completion(.failure(APIError.failedToGetData))
//            }
//        }
//        task.resume()
//    }
//}


// APICaller with Combine
class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    func requestAPI<T: Codable>(url: String, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: Constants.baseURL + url) else {
            return Fail(error: APIError.failedToGetData).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
