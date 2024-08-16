//
//  ChatBotEntity.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift

class ChatBotEntity: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var sessionId: Int
    @Persisted var messages: List<ChatBotMessageEntity>
}
