//
//  ThemeManager.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation
import UIKit

protocol ThemeChangeable {
    func applyTheme(_ theme: Theme)
}

enum Theme: Int {
    case light = 0
    case dark = 1
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        }
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var theme: Int = Theme.light.rawValue
    private let uiColor: UIColor = UIColor()
    
    private init() {}
    
    // theme variable
    var currentTheme: Theme {
        get {
            let currentTheme = Defaults.getInt(key: UserDefaultKeys.theme) ?? Theme.light.rawValue
            return Theme(rawValue: currentTheme) ?? .light
        }
        set {
            Defaults.setValue(value: newValue.rawValue, key: UserDefaultKeys.theme)
            
            // update published theme
            self.theme = newValue.rawValue
            applyTheme(newValue)
        }
    }
    
    func applyTheme(_ theme: Theme) {
        let backgroundColor = self.uiColor.themeBackground(for: theme)
        let textColor = self.uiColor.themeText(for: theme)
        
        // iOS 15 and for after
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
             windowScene?.windows.forEach { window in window.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
            }
        } else {
             // iOS 15 and for before
            UIApplication.shared.windows.forEach { window in window.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
            }
        }
        
        UILabel.appearance().textColor = textColor
        UIScrollView.appearance().backgroundColor = backgroundColor
                
        UITableView.appearance().backgroundColor = backgroundColor
        UITableViewCell.appearance().backgroundColor = backgroundColor
               
    }
}
