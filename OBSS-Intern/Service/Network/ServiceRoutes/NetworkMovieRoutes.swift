//
//  MovieServiceRoutes.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 1.08.2024.
//

import Foundation

extension NetworkServiceRoutes.NetworkMovieRoutes: URLRequestConvertible{
    // return url request, override method
    func makeRequest() throws -> URLRequest {
        var baseRequest: URLComponents = try makeBaseRequest(path: path)
        
        var finalQueryItems = baseRequest.queryItems ?? []
        
        if let newQueryItems = queryItems{
            finalQueryItems.append(contentsOf: newQueryItems)
        }
        
        baseRequest.queryItems = finalQueryItems
            
        // check url component is nill or not
        if baseRequest.url == nil {
           throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: baseRequest.url!)
        request.httpMethod = method
        
        // return url request
        return request
    }
    
    // returns path for MovieRoutes
    private var path: String {
        switch self {
        case .getPopulerMovies:
            return "/movie/popular"
        case .searchMovie:
            return "/search/movie"
        case .getMovie(let movieID):
            return "/movie/\(movieID)"
        case .getMovieCredits(let movieID):
            return "/movie/\(movieID)/credits"
        case .getMovieRecommendations(let movieId):
            return "/movie/\(movieId)/recommendations"
        case .getUpcomingMovies:
            return "/movie/upcoming"
        case .getDiscoverMovies:
            return "/discover/movie"
        }
    }
    
    // returns service method
    private var method: String{
        switch self{
        case .getPopulerMovies, .getMovie, .getMovieCredits, .getMovieRecommendations, .searchMovie, .getUpcomingMovies, .getDiscoverMovies:
            return NetworkMethods.GET.rawValue
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .getPopulerMovies(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .searchMovie(let searchText, let page):
            return [
                URLQueryItem(name: "query", value: searchText),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .getUpcomingMovies(let page, let releaseDate):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "release_date.gte", value: releaseDate),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "include_video", value: "false"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "with_release_type", value: "2|3"),
            ]
        case .getDiscoverMovies(let page):
            return [
                URLQueryItem(name: "page", value: String(page)),
            ]
        default:
            return nil
        }
    }
}
