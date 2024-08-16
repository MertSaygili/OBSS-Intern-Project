//
//  StorageManager.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//

import RealmSwift

class StorageManager{
    // singleton
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: --lazy realm
    private lazy var realm: Realm = {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }()
    
    // MARK: --realm getter
    var getRealmInstance: Realm {
        return self.realm
    }
}
