//
//  ServiceRouteManager.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 1.08.2024.
//

import Foundation

// protocol of returning URLComponents
protocol URLRequestConvertible{
    func makeRequest() throws -> URLRequest
}

// extension of url request convertible
extension URLRequestConvertible{
    // return base request
    func makeBaseRequest(path: String) throws -> URLComponents {
        var urlComponent: URLComponents? = URLComponents()
                
        urlComponent?.scheme = NetworkConstants.scheme
        urlComponent?.host = NetworkConstants.baseUrl
        urlComponent?.path = NetworkConstants.serviceVersion + path
                
        
        urlComponent?.queryItems = [
            URLQueryItem(name: "api_key", value: NetworkConstants.apiKey),
            URLQueryItem(name: "language", value: LocalizationManager.shared.getServiceLanguageCode())
        ]
        
        if urlComponent == nil{
            throw NetworkError.invalidUrl
        }
        
        return urlComponent!
    }
    
    func makeAIRequest(path: String) throws -> URLComponents {
        var urlComponent: URLComponents? = URLComponents()
                
        urlComponent?.scheme = NetworkConstants.scheme
        urlComponent?.host = NetworkConstants.chatBotBaseUrl
        urlComponent?.path = path
                
        if urlComponent == nil{
            throw NetworkError.invalidUrl
        }
        return urlComponent!
    }
}

enum NetworkServiceRoutes{
    // For = Movie Services
    enum NetworkMovieRoutes{
        case getPopulerMovies(page: Int)
        case searchMovie(searchText: String, page: Int)
        case getMovie(movieID: Int)
        case getMovieCredits(movieID: Int)
        case getMovieRecommendations(movieId: Int)
        case getUpcomingMovies(page: Int, releaseDate: String)
        case getDiscoverMovies(page: Int)
    }
    
    // For = Cast Servicess
    enum NetworkCastRoutes{
        case getPersonDetail(personId: Int)
        case getPersonCombinedCredits(personId: Int)
    }
    
    enum NetworkChatbotRoutes{
        case getChatbotMessage(message: String)
    }
}
