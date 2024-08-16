//
//  FavoritesViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import UIKit
import RealmSwift

class FavoritesViewController: BaseViewController {
    
    // MARK: --variables
    private let favoriteRepository: FavoriteMovieRepositoryProtocol = FavoriteMovieRepository()
    private let screenNavigationController: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    private let favoritesView: FavoritesView = FavoritesView()
    private var favoriteMovies: [MovieEntity] = [] {
        didSet {reloadData()}
    }
    
    private var favoriteMoviesObservation: NotificationToken?
    
    // MARK: --override functions
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFavoriteMovies()
        self.setupUI()
        self.setupFavoriteMoviesObservation()
        self.updateUIForEmptyState()
    }
    
    override func setupUI() {
        self.setUpCollections()
        self.setUpNavigationBar()
        self.favoritesView.applyTheme(ThemeManager.shared.currentTheme)
    }
    
    override func updateTheme() {
        self.setupUI()
        self.setUpNavigationBar()
    }
    
    override func updateLocalization() {
        setupUI()
    }
    
    // MARK: --private functions
    private func setUpCollections() {
        self.favoritesView.collectionView.register(FavoriteMoviesCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier)
        self.favoritesView.collectionView.delegate = self
        self.favoritesView.collectionView.dataSource = self
        
        self.favoritesView.collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)

    }
    
    private func setUpNavigationBar() {
        navigationItem.title = LocalizationKeys.Favorites.favoritesTitle.localize()
        
        let appearance = UINavigationBarAppearance()
        let currentTheme = ThemeManager.shared.currentTheme
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear.themeBackground(for: currentTheme)
        appearance.titleTextAttributes = [.foregroundColor: currentTheme == Theme.dark ? UIColor.white : UIColor.black, .font: UIFont.boldSystemFont(ofSize: 18)]
        appearance.shadowColor = currentTheme == Theme.dark ? UIColor.white : UIColor.black
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.favoritesView.createVerticalSection()
        }
    }
    
    private func getFavoriteMovies() {
        favoriteMovies = favoriteRepository.getFavoriteMovies().reversed()
        updateUIForEmptyState()
        reloadData()
    }
    
    private func navigateToDetail(movieId: Int, movieName: String) {
        guard let navController = self.navigationController else {return}
        screenNavigationController.pushMovieDetail(
            navigationController: navController,
            movieId: movieId,
            movieName: movieName
        )
    }
    
    private func setupFavoriteMoviesObservation() {
       favoriteMoviesObservation = StorageManager.shared.getRealmInstance.objects(FavoriteMovieEntity.self).observe { [weak self] (changes) in
           switch changes {
           case .initial(_):
               break
           case .update(_, deletions: _, insertions: _, modifications: _):
               guard let self = self else {return}
               self.getFavoriteMovies()
               self.reloadData()
               self.updateUIForEmptyState()
           case .error(_):
               break
           }
       }
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesView.collectionView.reloadData()
        }
    }
    
    private func updateUIForEmptyState() {
        if favoriteMovies.isEmpty {
            favoritesView.lottieErrorView.isHidden = false
            favoritesView.collectionView.isHidden = true
            favoritesView.lottieErrorView.play()
        } else {
            favoritesView.lottieErrorView.isHidden = true
            favoritesView.collectionView.isHidden = false
            favoritesView.lottieErrorView.stop()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier, for: indexPath) as? FavoriteMoviesCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = favoriteMovies[indexPath.item]
        cell.configure(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FavoriteMoviesCollectionViewCell else {return}
        cell.applyTheme(ThemeManager.shared.currentTheme)
        cell.configure(movie: favoriteMovies[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = self.favoriteMovies[indexPath.row]
        guard let movieId = entity.movieId else {return}
        self.navigateToDetail(movieId: movieId, movieName: entity.movieName ?? "")
    }
}
