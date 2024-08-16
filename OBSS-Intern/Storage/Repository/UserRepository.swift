//
//  UserRepository.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift
import UIKit

protocol UserRepositoryProtocol {
    func getUser(userId: String) -> UserEntity?
    func createUser(user: UserEntity) -> UserEntity?
    func initializeUsers()
}

class UserRepository: UserRepositoryProtocol {
    
    // MARK: --private properties
    private let realm: Realm = StorageManager.shared.getRealmInstance

    
    // MARK: --protocol functions
    func getUser(userId: String) -> UserEntity? {
        if let user = realm.objects(UserEntity.self).filter("userId == %@", userId).first{
            return user
        }
        
        return nil
    }
    
    func createUser(user: UserEntity) -> UserEntity? {
        if isUserExist(id: user.userId) {
            return getUser(userId: user.userId)
        }
        do {
            try realm.write {
                realm.add(user)
                return user
            }
        }
        catch {
            debugPrint("Error creating user: \(error)")
        }
        return nil
    }
    
    // MARK: --public functions
    func initializeUsers() {
        // already user initialized
        if Defaults.getBool(key: UserDefaultKeys.isUserDataSaved) == true {
            return
        }

        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            debugPrint("Error fetching device ID")
            return
        }
        
        let userId = deviceId
        let botId = "\(deviceId)-bot"
        
        // create user
        let user = UserEntity()
        user.userId = userId
        user.userName = "User"
        _ = createUser(user: user)
        
        // create bot
        let bot = UserEntity()
        bot.userId = botId
        bot.userName = "Bot"
        _ = createUser(user: bot)
        
        // user is initialized
        Defaults.setValue(value: true, key: UserDefaultKeys.isUserDataSaved)
    }
    
    // MARK: --private functions
    private func isUserExist(id: String) -> Bool {
        return realm.objects(UserEntity.self).filter("userId == %@", id).count > 0
    }
}
