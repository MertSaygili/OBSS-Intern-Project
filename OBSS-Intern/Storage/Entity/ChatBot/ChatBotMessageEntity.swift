//
//  ChatBotMessageEntity.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift
import Foundation

class ChatBotMessageEntity: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var senderId: String
    @Persisted var senderName: String
    @Persisted var messageId: String
    @Persisted var sendDate: Date
    @Persisted var message: String
}
