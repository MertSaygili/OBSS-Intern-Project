//
//  MovieListDetailViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 13.08.2024.
//

import UIKit
import RealmSwift

class MovieListDetailViewController: BaseViewController {
    
    // MARK: --variables
    private let movieListDetailView: MovieListDetailView = MovieListDetailView()
    private let customListRepository: CustomListRepositoryProtocol = CustomListRepository()
    private let screenNavigationController : ScreenNavigationManagerProtocol = ScreenNavigationManager()
    
    private var listID: ObjectId = ObjectId()
    private var listNAME: String = ""
    private var listMovies: [MovieEntity] = [] {
        didSet{loadData()}
    }
    
    // MARK: --getter and setters
    var listName: String{
        get{
            return listNAME
        }
        set{
            listNAME = newValue
        }
    }
    
    var listId: ObjectId {
        get {
            return listID
        }
        set {
            listID = newValue
        }
    }
    
    // MARK: --override functions
    override func loadView() {
        view = movieListDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        getListMovies()
        setupCollections()
        setupNavigationController()
    }
    
    override func updateTheme() {
        self.setupUI()
    }
    
    override func updateLocalization() {
        setupUI()
    }
    
    // MARK: --private functions
    private func setupCollections() {
        self.movieListDetailView.movieCollectionView .register(FavoriteMoviesCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier)
        self.movieListDetailView.movieCollectionView.delegate = self
        self.movieListDetailView.movieCollectionView.dataSource = self
        self.movieListDetailView.movieCollectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    private func setupNavigationController() {
        guard let navController = self.navigationController else {return}
        movieListDetailView.setUpNavigationBar(navigationItem: self.navigationItem, navigationController: navController, title: listName)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.movieListDetailView.createVerticalSection()
        }
    }
    
    private func getListMovies() {
        if let list = customListRepository.getCustomList(id: listId) {
            listMovies = Array(list.movies)
        } else {
            listMovies = []
        }
    }
    
    private func loadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieListDetailView.movieCollectionView.reloadData()
        }
    }
    
    private func pushMovieDetailViewController(movieName: String, movieId: Int) {
        guard let navController = self.navigationController else { return }

        screenNavigationController.pushMovieDetail(navigationController: navController, movieId: movieId, movieName: movieName)
    }
}


extension MovieListDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier, for: indexPath) as? FavoriteMoviesCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = listMovies[indexPath.item]
        cell.configure(movie: movie)
        return cell
    }
}



extension MovieListDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = listMovies[indexPath.row]
        
        if entity.movieId == nil {
            return
        }
        
        pushMovieDetailViewController(movieName: entity.movieName ?? "", movieId: entity.movieId!)
    }
}
