//
//  CustomUserList.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 13.08.2024.
//

import RealmSwift

class CustomUserList: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var list: List<CustomListEntity>
}
