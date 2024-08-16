//
//  FavoriteMovieRepository.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//
//
//import Foundation
//import CoreData

import RealmSwift

protocol FavoriteMovieRepositoryProtocol{
    func getFavoriteMovies() -> [MovieEntity]
    func addFavoriteMovie(movie: MovieEntity)
    func deleteFavoriteMovie(id: Int?)
    func isMovieExists(id: Int?) -> Bool
}

class FavoriteMovieRepository: FavoriteMovieRepositoryProtocol {
    // MARK: --variables
    private let realm: Realm = StorageManager.shared.getRealmInstance
    
    // MARK: --protocol functions
    func getFavoriteMovies() -> [MovieEntity] {
        guard let favoriteMoviesEntity = realm.objects(FavoriteMovieEntity.self).first else {
            return []
        }
        return Array(favoriteMoviesEntity.movies)
    }
    
    func addFavoriteMovie(movie: MovieEntity) {
        if movie.movieId == nil{
            return
        }
        
        do {
            // movie already exist, then do not add it
            if isMovieIdExist(id: movie.movieId!) == true{
                return
            }
            // add movie to favoriteMoviesEntity List
            try realm.write {
                let favoriteMoviesEntity = realm.objects(FavoriteMovieEntity.self).first ?? FavoriteMovieEntity()
                favoriteMoviesEntity.movies.append(movie)
                realm.add(favoriteMoviesEntity, update: .modified)
            }
        } catch {
            print("Error adding favorite movie: \(error)")
        }
    }
    
    func deleteFavoriteMovie(id: Int?) {
        if id == nil{
            return
        }
        
        do {
            if let favoriteMoviesEntity = realm.objects(FavoriteMovieEntity.self).first,
               let movieToDelete = favoriteMoviesEntity.movies.filter("movieId == %@", id!).first {
                try realm.write {
                    favoriteMoviesEntity.movies.remove(at: favoriteMoviesEntity.movies.index(of: movieToDelete)!)
                }
            }
        } catch {
           debugPrint("MIS--Error Accur While Deleting Movie")
        }
    }
    
    func isMovieExists(id: Int?) -> Bool{
        if let id = id{
            return isMovieIdExist(id: id)
        }
        return false
    }
    
    private func isMovieIdExist(id: Int) -> Bool {
        if let favoriteMoviesEntity = realm.objects(FavoriteMovieEntity.self).first{
            let movieToDelete = favoriteMoviesEntity.movies.filter("movieId == %@", id).first
            
            if movieToDelete != nil{
                return true
            }
        }
        return false
    }
}
