//
//  CastServiceRoutes.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 1.08.2024.
//

import Foundation

extension NetworkServiceRoutes.NetworkCastRoutes: URLRequestConvertible {
    // return url request, override method
    func makeRequest() throws -> URLRequest {
        let baseRequest = try makeBaseRequest(path: path)
        
        // check url component is nill or not
        if baseRequest.url == nil {
           throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: baseRequest.url!)
        request.httpMethod = method
        
        // return url request
        return request
    }
    
    // returns path for CastRoutes
    private var path: String {
        switch self {
        case .getPersonDetail(let personId):
            return "/person/\(personId)"
        case .getPersonCombinedCredits(let personId):
            return "/person/\(personId)/combined_credits"
        }
    }
    
    // returns url method
    private var method: String{
        switch self{
        case .getPersonDetail, .getPersonCombinedCredits:
            return NetworkMethods.GET.rawValue
        }
    }
}
