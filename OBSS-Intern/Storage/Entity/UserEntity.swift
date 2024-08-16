//
//  UserEntity.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift

class UserEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userId: String
    @Persisted var userName: String
}
