//
//  MovieEntity.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//

import RealmSwift

class MovieEntity: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var movieId: Int?
    @Persisted var movieName: String?
    @Persisted var movieImagePath: String?
}
