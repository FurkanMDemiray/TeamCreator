//
//  NetworkManager.swift
//  TeamCreator
//
//  Created by Melik Demiray on 29.07.2024.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetch<T>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable
}

final class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()

    private init() { }

    func fetch<T>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
