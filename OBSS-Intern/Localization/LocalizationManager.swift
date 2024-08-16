// LocalizationManager.swift
// OBSS-Intern
//
// Created by Mert Saygılı on 29.07.2024.
//

import Foundation

// Supported Languages Enum
enum SupportedLanguages: String {
    case tr
    case en
    
    init?(locale: String) {
        self.init(rawValue: locale.lowercased())
    }
    
    var getServiceLanguage: String{
        switch self {
        case .tr:
            "tr-TR"
        case .en:
            "en-US"
        }
    }
    
    func getLanguage(languageCode: String) -> SupportedLanguages{
        switch languageCode {
        case "tr":
            SupportedLanguages.tr
        case "en":
            SupportedLanguages.en
        default:
            SupportedLanguages.en
            
        }
    }
}

class LocalizationManager: ObservableObject {
    // Singleton instance
    static let shared: LocalizationManager = LocalizationManager()
    
    @Published var languageCode: String = SupportedLanguages.en.rawValue
    
    private init() {}
    
    // for setting device language as a primary language for app
    func setDeviceLanguageAsDefault() {
        var locale: String? = nil
        
        // if user has already set the language, then return
        if let language = getCurrentLanguage() {
            self.languageCode = language.rawValue
            return
        }
        
        // get language from device
        if #available(iOS 16, *) {
             locale = Locale.current.language.languageCode?.identifier
        } else {
            // Fallback on earlier versions
            locale = Locale.current.languageCode
            
        }
        
        // if device language is nil then set language en
        if locale == nil{
            setLanguage(language: SupportedLanguages.en)
            return
        }
        
        
        if let supportedLanguage = SupportedLanguages(locale: locale!) {
            // set device language
            setLanguage(language: supportedLanguage)
        } else {
            // default language
            setLanguage(language: .en)
        }
    }
    
    // Set device language by gived language enum
    func setLanguage(language: SupportedLanguages) {
        Defaults.setValue(value: language.rawValue, key: UserDefaultKeys.language)
        
        // change language
        self.languageCode = language.rawValue
                
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
          let bundle = Bundle(path: path) {
            Bundle.main.localizedBundle = bundle
       }
    }
    
    // Change language to TR or EN, for testing and etc
    func changeLanguage() {
        let currentLanguage: String = Defaults.getString(key: UserDefaultKeys.language) ?? SupportedLanguages.en.rawValue
        let currentSupportedLanguage: SupportedLanguages = SupportedLanguages.init(locale: currentLanguage) ?? SupportedLanguages.en
        
        switch currentSupportedLanguage {
        case SupportedLanguages.en:
            setLanguage(language: SupportedLanguages.tr)
        case SupportedLanguages.tr:
            setLanguage(language: SupportedLanguages.en)
        }
    }
    
    // For getting current language
    func getCurrentLanguage() -> SupportedLanguages? {
        guard let language = Defaults.getString(key: UserDefaultKeys.language) else {
            return nil
        }
        // returns currnt language
        return SupportedLanguages(locale: language) ?? .en
    }
    
    func getServiceLanguageCode() -> String{
        let currentLanguage = Defaults.getString(key: UserDefaultKeys.language) ?? SupportedLanguages.en.rawValue
        let supportedLanguageValue = SupportedLanguages.init(locale: currentLanguage) ?? SupportedLanguages.en
        
        return supportedLanguageValue.getServiceLanguage
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0

    static let once: Void = {
        object_setClass(Bundle.main, PrivateBundle.self)
    }()
    
    var localizedBundle: Bundle? {
        get {
            return objc_getAssociatedObject(self, &Bundle.bundleKey) as? Bundle
        }
        set {
            objc_setAssociatedObject(self, &Bundle.bundleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = Bundle.main.localizedBundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
