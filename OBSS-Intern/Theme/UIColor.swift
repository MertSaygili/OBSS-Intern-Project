//
//  UIColor.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation
import UIKit

extension UIColor {
    func themeBackground(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return .white
        case .dark:
            return UIColor(rgb: 0xff1C1C1E)
        }
    }
    
    func themeText(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    func themeTabBarText(for theme: Theme) -> UIColor{
        switch theme{
        case .light:
            return .lightGray
        case .dark:
            return .white
        }
    }
    
    func themeTabBarIconColor(for theme: Theme) -> UIColor{
        switch theme{
        case .light:
            return .link
        case .dark:
            return .link
        }
    }
    
    func themeCardBackgroundColor(for theme: Theme) -> UIColor{
        switch theme{
        case .light:
            return .white
        case .dark:
            return UIColor(rgb: 0xff2C2C2E)
        }
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
