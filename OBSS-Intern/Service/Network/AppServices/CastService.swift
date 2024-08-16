//
//  CastServices.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

protocol CastServiceProtocol{
    func getPersonDetail(personId: Int, completion: @escaping (Result<PersonModel, NetworkError>) -> Void)
    func getPersonCombinedCredits(personId: Int, completion: @escaping (Result<BasePersonMovieModelResponse, NetworkError>) -> Void)
}

class CastService: CastServiceProtocol{
    func getPersonDetail(personId: Int, completion: @escaping (Result<PersonModel, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkCastRoutes.getPersonDetail(personId: personId).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func getPersonCombinedCredits(personId: Int, completion: @escaping (Result<BasePersonMovieModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkCastRoutes.getPersonCombinedCredits(personId: personId).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
}
