//
//  SearchMoviesViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import UIKit

class SearchViewController: BaseViewController {
    
    // MARK: --variables
    private let movieService: MovieServiceProtocol = MovieService()
    private let searchView: SearchView = SearchView()
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    
    private var searchTimer: Timer?
    private var pageCount = 1
    private var oldQuery: String = ""
    private var newQuery: String = ""
    
    private var searchMovies: [MovieModel] = [] {
        didSet{reloadSearchMovieDatas()}
    }
    
    // MARK: --override functions
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dismissKeyboardSetup()
        searchBarDelegateSetup()
        tableViewDelegateSetup()
        setupFloatingAiButton()
    }
    
    override func setupUI() {
        if let navigationController = self.navigationController {
            searchView.setUpNavigationBar(navigationItem: self.navigationItem, navigationController: navigationController)
            searchView.applyTheme(ThemeManager.shared.currentTheme)
        }
    }
    
    override func updateTheme() {
        setupUI()
    }
    
    override func updateLocalization() {
        self.setupUI()
        self.searchView.configureTexts()
    }
    
    // MARK: --private functions
    private func dismissKeyboardSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    private func searchBarDelegateSetup() {
        self.searchView.movieSearchBar.delegate = self
    }
    
    private func tableViewDelegateSetup() {
        self.searchView.movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        self.searchView.movieTableView.delegate = self
        self.searchView.movieTableView.dataSource = self
    }
    
    private func searchMovie(searchText: String) {
        if searchText.isEmpty {
            self.searchMovies = []
            reloadSearchMovieDatas()
        }
        
        if(oldQuery == searchText){
            pageCount += 1
        }
        else{
            pageCount = 1
        }
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        movieService.searchMovie(searchText: query, page: pageCount, completion:  { [weak self] result in
            guard let self else {return}
                    
            switch result {
            case .success(let data):
                if pageCount == 1 {
                    self.searchMovies = data.results ?? []
                }
                else{
                    self.searchMovies.append(contentsOf: data.results ?? [])
                }
                oldQuery = searchText
                reloadSearchMovieDatas()
            case .failure(let error):
                ToastServiceManager.showToast(message: error.localizedDescription, view: self.view)
            }
        })
    }
    
    private func setupFloatingAiButton() {
        self.searchView.floatingAIChatButton.addTarget(self, action: #selector(navigateToChatBot), for: .touchUpInside)
    }
    
    private func reloadSearchMovieDatas() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.searchView.movieTableView.reloadData()
            self.loadViewIfNeeded()
        }
    }
    
    private func navigateToDetail(movieId: Int, movieName: String) {
        guard let navController = self.navigationController else {return}
        self.screenNavigationManager.pushMovieDetail(
            navigationController: navController,
            movieId: movieId,
            movieName: movieName
        )
    }
    
    // MARK: --objc functions
    @objc func dismissKeyboard() {
          view.endEditing(true)
    }
        
    @objc func navigateToChatBot() {
        guard let navController = self.navigationController else {return}
        self.screenNavigationManager.pushToChatBot(navigationController: navController)
    }
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configure(movie: self.searchMovies[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchMovies.count - 3 {
            self.searchMovie(searchText: newQuery)
        }
        
        guard let cell = cell as? MovieTableViewCell else {return}
        
        cell.configure(movie: self.searchMovies[indexPath.row])
//        cell.applyTheme(ThemeManager.shared.currentTheme)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is MovieTableViewCell else {return}
            
        let movie = self.searchMovies[indexPath.row]
        self.navigateToDetail(movieId: movie.id ?? 0, movieName: movie.title ?? "")
    }
}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTimer?.invalidate()
        self.newQuery = searchText
        self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { [weak self] _ in
            self?.searchMovie(searchText: searchText)
        })
    }
}

