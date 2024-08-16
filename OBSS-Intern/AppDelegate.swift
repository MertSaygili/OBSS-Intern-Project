//
//  AppDelegate.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 22.07.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalizationManager.shared.setDeviceLanguageAsDefault()
        ThemeManager.shared.applyTheme(ThemeManager.shared.currentTheme)
        
        // Initialize user and custom list
        UserRepository().initializeUsers()
        CustomListRepository().initializeCustomList()
        
        // request authorization for local notification
        LocalNotificationService.shared.requestNotificationPermission()
        LocalNotificationService.shared.initNotifications()
        
        // notification settings
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // USER NOTIFICATION CENTER DELEGATE METHODS
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        let separator = NotificationSplittedKey.key.rawValue
        let splittedData = identifier.components(separatedBy: separator)
        
        // 3 is the expected count of splitted data, identifier + id + title, if it is not 3, it means that the notification is not valid or we miss u notification
        if splittedData.count == 3 {
            let movieId = splittedData[SplittedKeyResults.id.rawValue]
            let movieTitle = splittedData[SplittedKeyResults.title.rawValue]
            
            if let movieId = Int(movieId) {
                // get all controllers
                let controllers = UIApplication.shared.windows.first?.rootViewController?.children
                // find tabbar view controller
                let tabbarViewController = controllers?.first(where: { $0 is TabbarViewController }) as? TabbarViewController
                tabbarViewController?.navigateToMovieDetail(movieId: movieId, movieTitle: movieTitle)
            }
        }
        
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       // Handle foreground presentation options
       completionHandler([.alert, .sound, .badge])
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
