//
//  ChatBotRepository.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift

protocol ChatBotRepositoryProtocol {
    func getLastSession() -> Int
    func getMessages(sessionId: Int) -> [ChatBotMessageEntity]
    func createSession() -> Int
    func addMessage(sessionId: Int, message: ChatBotMessageEntity)
    func deleteSession(sessionId: Int)
}

class ChatBotRepository: ChatBotRepositoryProtocol {
    
    // MARK: --variables
    private let realm: Realm = StorageManager.shared.getRealmInstance

    // MARK: --protocol functions
    func getMessages(sessionId: Int) -> [ChatBotMessageEntity] {
        if let chatBot = realm.objects(ChatBotEntity.self).filter("sessionId == %@", sessionId).first {
            return Array(chatBot.messages)
        }
        return []
    }
    
    func createSession() -> Int {
        let chatBot = ChatBotEntity()
        chatBot.sessionId = Int.random(in: 1...1000)
        if realm.objects(ChatBotEntity.self).filter("sessionId == %@", chatBot.sessionId).count > 0 {
            return createSession()
        }
        
        do {
            try realm.write {
                realm.add(chatBot)
            }
        } catch {
            debugPrint("Error creating session: \(error)")
        }
        
        return chatBot.sessionId
    }
    
    func addMessage(sessionId: Int, message: ChatBotMessageEntity) {
        do {
            if let session = realm.objects(ChatBotEntity.self).filter("sessionId == %@", sessionId).first {
                try realm.write {
                    session.messages.append(message)
                }
            }
        } catch {
            debugPrint("Error adding message: \(error)")
        }
    }
    
    func getLastSession() -> Int {
        if let id = realm.objects(ChatBotEntity.self).last?.sessionId {
            return id
        }
        
        return createSession()
    }
    
    func deleteSession(sessionId: Int) {
        do {
            if let chatBot = realm.objects(ChatBotEntity.self).filter("sessionId == %@", sessionId).first {
                try realm.write {
                    realm.delete(chatBot)
                }
            }
        } catch {
            debugPrint("Error deleting session: \(error)")
        }
    }
}
