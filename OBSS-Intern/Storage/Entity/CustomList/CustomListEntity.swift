//
//  CustomListEntity.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift

class CustomListEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var listName: String
    @Persisted var movies: List<MovieEntity>
}
