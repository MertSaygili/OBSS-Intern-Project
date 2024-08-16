//
//  ServiceManager.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

class NetworkManager{
    
    // singleton instance
    static let shared:NetworkManager = NetworkManager()
        
    private init() {}
    
    func request<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.error))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
                        
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError: decodingError)))
            }
        }
        task.resume()
    }
 }
