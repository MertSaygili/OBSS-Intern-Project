//
//  MovieServices.swift
//  OBSS-Intern
///Users/mertsaygili/develop/obss-intern/mert.saygili/OBSS-Intern/OBSS-Intern/Service/ServiceRoutes.swift
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

protocol MovieServiceProtocol{
    func getPopularMovies(page: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void)
    func searchMovie(searchText: String, page: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void)
    func getMovieById(movieId: Int, completion: @escaping (Result<MovieDetailModel, NetworkError>) -> Void)
    func getMovieCredits(movieId: Int, completion: @escaping (Result<BaseCreditModelResponse, NetworkError>) -> Void)
    func getMovieRecommendations(movieId: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void)
    func getUpcomingMovies(page: Int, releaseDate: String, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void)
    func getDisoverMovies(page: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void)
}

class MovieService: MovieServiceProtocol{
    
    func getPopularMovies(page: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.getPopulerMovies(page: page).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func searchMovie(searchText: String, page: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.searchMovie(searchText: searchText, page: page).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func getMovieById(movieId: Int, completion: @escaping (Result<MovieDetailModel, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.getMovie(movieID: movieId).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func getMovieCredits(movieId: Int, completion: @escaping (Result<BaseCreditModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.getMovieCredits(movieID: movieId).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func getMovieRecommendations(movieId: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.getMovieRecommendations(movieId: movieId).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func getUpcomingMovies(page: Int, releaseDate: String, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.getUpcomingMovies(page: page, releaseDate: releaseDate).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func getDisoverMovies(page: Int, completion: @escaping (Result<BaseMovieModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkMovieRoutes.getDiscoverMovies(page: page).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
}
