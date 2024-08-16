//
//  TabbarViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import UIKit
import Combine

enum Tabs: Int {
    case popularMovies = 0
    case searchMovie = 1
    case favorites = 2
    case settings = 3
}

class TabbarViewController: UITabBarController, BaseViewControllerProtocol {

    // MARK: --varibles
    private var cancellables = Set<AnyCancellable>()
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setTabBarItems()
        setupLanguageObserver()
        setupThemeObserver()
    }
    
    // MARK: --override functions
    func setupUI() {}
    
    func updateLocalization() {
        setTabBarItems()
    }
    
    func updateTheme() {
        setTabBarItems()
    }
    
    func navigateToMovieDetail(movieId: Int, movieTitle: String) {
        guard let selectedNavController = self.selectedViewController as? UINavigationController else { return }

        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieID = movieId
        movieDetailViewController.movieTitle = movieTitle
        
        selectedNavController.pushViewController(movieDetailViewController, animated: true)
    }
    
    // MARK: --private functions
    private func setupLanguageObserver() {
        LocalizationManager.shared.$languageCode
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateLocalization()
            }.store(in: &cancellables)
    }
    
    // theme observer, will be triggered when user changes theme
    private func setupThemeObserver() {
        ThemeManager.shared.$theme
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateTheme()
            }.store(in: &cancellables)
    }
    
    private func setupViewControllers() {
        let homeViewController = HomeViewController()
        let searchMovieViewController = SearchViewController()
        let favoritesViewController = FavoritesViewController()
        let settingsViewController = ProfileViewController()
        
        let homeNav = UINavigationController(rootViewController: homeViewController)
        let searchNav = UINavigationController(rootViewController: searchMovieViewController)
        let favoriteNav = UINavigationController(rootViewController: favoritesViewController)
        let settingsNav = UINavigationController(rootViewController: settingsViewController)
        
        viewControllers = [homeNav, searchNav, favoriteNav, settingsNav]
    }
}
