//
//  FavoriteMovieEntity.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//

import RealmSwift

class FavoriteMovieEntity: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var movies: List<MovieEntity>
}
