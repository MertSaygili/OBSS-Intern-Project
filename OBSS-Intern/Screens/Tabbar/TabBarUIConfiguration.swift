//
//  TabBarUIConfiguration.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import Foundation
import UIKit

extension TabbarViewController{
    func setTabBarItems() -> Void{
        let currentTheme = ThemeManager.shared.currentTheme
        tabBar.backgroundColor = UIColor.clear.themeBackground(for: currentTheme)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear.themeBackground(for: currentTheme)
        
        let selectedTextColor = UIColor.label.themeTabBarText(for: currentTheme)
        let selectedIconColor = UIColor.label.themeTabBarIconColor(for: currentTheme)
        
        appearance.shadowColor = selectedTextColor
        
        appearance.stackedLayoutAppearance.selected.iconColor = selectedIconColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedIconColor]
        appearance.stackedLayoutAppearance.normal.iconColor = selectedTextColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: selectedTextColor]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        if let tabBarItems = self.tabBar.items {
            for item: UITabBarItem in tabBarItems {
                
                switch tabBarItems.firstIndex(of: item)!{
                case Tabs.popularMovies.rawValue:
                    item.title = LocalizationKeys.Tabs.moviesTitle.localize()
                    item.image = AppImageConstants.movieTabImage.withRenderingMode(.alwaysTemplate)
                    item.selectedImage = AppImageConstants.movieTabImage.withRenderingMode(.alwaysTemplate)
                case Tabs.searchMovie.rawValue:
                    item.title = LocalizationKeys.Tabs.searchMovieTitle.localize()
                    item.image = AppImageConstants.searchMovieTabImage.withRenderingMode(.alwaysTemplate)
                    item.selectedImage = AppImageConstants.searchMovieTabImage.withRenderingMode(.alwaysTemplate)
                case Tabs.favorites.rawValue:
                    item.title = LocalizationKeys.Tabs.favoritesTitle.localize()
                    item.image = AppImageConstants.favoritesTabImage.withRenderingMode(.alwaysTemplate)
                    item.selectedImage = AppImageConstants.favoritesTabImage.withRenderingMode(.alwaysTemplate)
                case Tabs.settings.rawValue:
                    item.title = LocalizationKeys.Tabs.profileTitle.localize()
                    item.image = AppImageConstants.personTabImage.withRenderingMode(.alwaysTemplate)
                    item.selectedImage = AppImageConstants.personTabImage.withRenderingMode(.alwaysTemplate)
                default:
                    break
                }
            }
        }
    }
}
