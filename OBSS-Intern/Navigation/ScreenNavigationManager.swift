//
//  ScreenNavigationController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 6.08.2024.
//

import RealmSwift
import UIKit

// ScreenNavigationManagerProtocol
protocol ScreenNavigationManagerProtocol {
    func pushHome(navigationController: UINavigationController)
    func pushMovieDetail(navigationController: UINavigationController, movieId: Int, movieName: String)
    func pushPersonDetail(navigationController: UINavigationController, personId: Int, personName: String)
    func pushToChatBot(navigationController: UINavigationController)
    func pushToLanguage(navigationController: UINavigationController)
    func pushMovieLists(navigationController: UINavigationController)
    func pushMovieListDetail(navigationController: UINavigationController, listId: ObjectId, listName: String)
}

// ScreenNavigationManager class
final class ScreenNavigationManager: ScreenNavigationManagerProtocol {
    func pushHome(navigationController: UINavigationController) {
        navigationController.pushHomeViewController()
    }
    
    func pushMovieDetail(navigationController: UINavigationController, movieId: Int, movieName: String) {
        navigationController.pushMovieDetailViewController(movieId: movieId, movieName: movieName)
    }
    
    func pushPersonDetail(navigationController: UINavigationController, personId: Int, personName: String) {
        navigationController.pushPersonDetailViewController(personId: personId, personName: personName)
    }
    
    func pushToChatBot(navigationController: UINavigationController) {
        navigationController.pushChatBotViewController()
    }
    
    func pushToLanguage(navigationController: UINavigationController) {
        navigationController.pushLanguageViewController()
    }
    
    func pushMovieLists(navigationController: UINavigationController) {
        navigationController.pushMovieLists(navigationController: navigationController)
    }
    
    func pushMovieListDetail(navigationController: UINavigationController, listId: ObjectId, listName: String) {
        navigationController.pushMovieListDetailViewController(listId: listId, listName: listName)
    }
}

// Private extensions for navigation
private extension UINavigationController {
    func pushHomeViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: TabbarViewController.identifier) as? TabbarViewController else {
            return
        }
        setViewControllers([tabBarController], animated: true)
    }
    
    func pushMovieDetailViewController(movieId: Int, movieName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailController = storyboard.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {
            return
        }
        movieDetailController.movieID = movieId
        movieDetailController.movieTitle = movieName
        pushViewController(movieDetailController, animated: false)
    }
    
    func pushPersonDetailViewController(personId: Int, personName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let personDetailController = storyboard.instantiateViewController(withIdentifier: PersonDetailViewController.identifier) as? PersonDetailViewController else {
            return
        }
        personDetailController.personId = personId
        personDetailController.personName = personName
        pushViewController(personDetailController, animated: false)
    }
    
    func pushChatBotViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chatBotController = storyboard.instantiateViewController(withIdentifier: ChatBotViewController.identifier) as? ChatBotViewController else {
            return
        }
        pushViewController(chatBotController, animated: false)
    }
    
    func pushLanguageViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let languageController = storyboard.instantiateViewController(withIdentifier: LanguageViewController.identifier) as? LanguageViewController else {
            return
        }
        pushViewController(languageController, animated: false)
    }
    
    func pushMovieLists(navigationController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieListController = storyboard.instantiateViewController(withIdentifier: MovieListViewController.identifier) as? MovieListViewController else {
            return
        }
        navigationController.pushViewController(movieListController, animated: true)
    }
    
    func pushMovieListDetailViewController(listId: ObjectId, listName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieListDetailController = storyboard.instantiateViewController(withIdentifier: MovieListDetailViewController.identifier) as? MovieListDetailViewController else {
            return
        }
        movieListDetailController.listId = listId
        movieListDetailController.listName = listName
        pushViewController(movieListDetailController, animated: false)
    }
}
