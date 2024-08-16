//
//  UserDefaultsManager.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import Foundation

// Defaults Keys
enum UserDefaultKeys: String{
    case theme
    case language
    case isUserDataSaved
    case isCustomListInitialized
}

// User Default Protocol
protocol UserDefaultsProtocol{
    static func setValue<T>(value:T, key: UserDefaultKeys)
    static func getString(key: UserDefaultKeys) -> String?
    static func getBool(key: UserDefaultKeys) -> Bool?
    static func getInt(key: UserDefaultKeys) -> Int?
    static func removeValue(key: UserDefaultKeys)
}

struct Defaults: UserDefaultsProtocol {
    // instance of UserDefaults
    private static let defaults = UserDefaults.standard

    static func setValue<T>(value: T, key: UserDefaultKeys) {
        defaults.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getString(key: UserDefaultKeys) -> String? {
        defaults.string(forKey: key.rawValue)
    }
    
    static func getBool(key: UserDefaultKeys) -> Bool? {
        defaults.bool(forKey: key.rawValue)
    }

    static func getInt(key: UserDefaultKeys) -> Int? {
        defaults.integer(forKey: key.rawValue)
    }

    static func removeValue(key: UserDefaultKeys){
        defaults.removeObject(forKey: key.rawValue)
    }
}
