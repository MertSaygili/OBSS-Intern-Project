import UIKit
import RealmSwift

enum HomeScreenSection: Int, CaseIterable {
    case upcomingMovies = 0
    case popularMovies = 1
}

class HomeViewController: BaseViewController {
    
    // MARK: --variabless
    private let movieService: MovieServiceProtocol = MovieService()
    private let homeView: HomeView = HomeView()
    private let screenNavigationController: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    private let favoriteMovieRepository: FavoriteMovieRepositoryProtocol = FavoriteMovieRepository()
    private var favoriteMoviesObservation: NotificationToken?
    
    private var isLoading: [Bool] = [true, true]
    private var paginationLoading: [Bool] = [false, false]
    private var upcomingMoviesPageCount = 1
    private var popularMoviesPageCount = 1
    
    private var upcomingMovies: [MovieModel] = [] {
        didSet{reloadCollectionView()}
    }
    private var popularMovies: [MovieModel] = [] {
        didSet{reloadCollectionView()}
    }
    
    deinit {
        favoriteMoviesObservation?.invalidate()
    }

    // MARK: --override functions
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        setupUI()
        setupFavoriteMoviesObservation()

    }
    
    override func setupUI() {
        if let navController = self.navigationController {
            let navigationItem = self.navigationItem
            self.homeView.setUpNavigationBar(navigationItem: navigationItem, navigationController: navController)
        }
    }
    
    override func updateTheme() {
        setupUI()
        setupCollectionView()
    }
    
    override func updateLocalization() {
        upcomingMovies.removeAll()
        popularMovies.removeAll()
        upcomingMoviesPageCount = 1
        popularMoviesPageCount = 1
        
        fetchMovies()
        setupUI()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController {
            homeView.setUpNavigationBar(navigationItem: self.navigationItem, navigationController: navigationController)
        }
    }
    
    // MARK: --private functions
    private func setupCollectionView() {
        homeView.collectionView.register(UpcomingMovieCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingMovieCollectionViewCell.identifier)
        homeView.collectionView.register(PopularMoviesCollectionViewCell.self, forCellWithReuseIdentifier: PopularMoviesCollectionViewCell.identifier)
        homeView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)

        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self

        homeView.collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = HomeScreenSection(rawValue: sectionIndex)
            switch section {
            case .upcomingMovies:
                return self.homeView.createHorizontalSection()
            case .popularMovies:
                return self.homeView.createVerticalSection()
            case .none:
                return nil
            }
        }
    }
    
    private func fetchMovies() {
        self.homeView.loadingView.startAnimating()
        
        fetchUpcomingMovies()
        fetchPopularMovies()
    }
    
    private func fetchUpcomingMovies() {
        guard !paginationLoading[HomeScreenSection.upcomingMovies.rawValue] else { return }
        paginationLoading[HomeScreenSection.upcomingMovies.rawValue] = true

        let date = Date()
        
        movieService.getUpcomingMovies(page: upcomingMoviesPageCount, releaseDate: String(describing: date)) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                self.upcomingMovies.append(contentsOf: data.results ?? [])
                self.reloadCollectionView()
                upcomingMoviesPageCount += 1
            case .failure(let error):
                ToastServiceManager.showToast(message: error.localizedDescription, view: self.homeView)
            }
            
            self.paginationLoading[HomeScreenSection.upcomingMovies.rawValue] = false
            self.isLoading[HomeScreenSection.upcomingMovies.rawValue] = false
            self.checkLoading()
        }
    }
    
    private func fetchPopularMovies() {
        guard !paginationLoading[HomeScreenSection.popularMovies.rawValue] else { return }
        paginationLoading[HomeScreenSection.popularMovies.rawValue] = true

        movieService.getPopularMovies(page: popularMoviesPageCount) { [weak self] result in
            guard let self else {return}

            switch result {
            case .success(let data):
                self.popularMovies.append(contentsOf: data.results ?? [])
                self.reloadCollectionView()
                popularMoviesPageCount += 1
            case .failure(let error):
                ToastServiceManager.showToast(message: error.localizedDescription, view: self.homeView)
            }
            
            self.paginationLoading[HomeScreenSection.popularMovies.rawValue] = false
            self.isLoading[HomeScreenSection.popularMovies.rawValue] = false
            self.checkLoading()
        }
    }
    
    private func checkLoading() {
        if self.isLoading[0] == false && self.isLoading[1] == false{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.homeView.loadingView.stopAnimating()
                self.reloadCollectionView()
                self.loadViewIfNeeded()
            }
        }
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.homeView.collectionView.reloadData()
        }
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
           guard let self else {return}

           switch changes {
           case .initial(_):
               break
           case .update(_, deletions: _, insertions: _, modifications: _):
               self.reloadCollectionView()
           case .error(_):
               break
           }
       }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let section = HomeScreenSection(rawValue: indexPath.section) else { return false}

        switch section{
        case .upcomingMovies:
            guard let id = upcomingMovies[indexPath.row].id else {return false}
            navigateToDetail(movieId: id, movieName: upcomingMovies[indexPath.row].title ?? "")
        case .popularMovies:
            guard let id = popularMovies[indexPath.row].id else {return false}
            navigateToDetail(movieId: id, movieName: popularMovies[indexPath.row].title ?? "")
            break
        }
        
        return false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeScreenSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeScreenSection(rawValue: section) else { return 0 }
        switch section {
        case .upcomingMovies:
            return upcomingMovies.count
        case .popularMovies:
            return popularMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeScreenSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .upcomingMovies:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMovieCollectionViewCell.identifier, for: indexPath) as! UpcomingMovieCollectionViewCell
            cell.configure(movie: upcomingMovies[indexPath.row])
            return cell
        case .popularMovies:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMoviesCollectionViewCell.identifier, for: indexPath) as! PopularMoviesCollectionViewCell
            cell.configure(movie: popularMovies[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = HomeScreenSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .upcomingMovies:
            if indexPath.row == upcomingMovies.count - 1 {
                fetchUpcomingMovies()
            }
        case .popularMovies:
            if indexPath.row == popularMovies.count - 1 {
                fetchPopularMovies()
            }
        }
        
        if let themeCell = cell as? ThemeChangeable {
            themeCell.applyTheme(ThemeManager.shared.currentTheme)
          }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
            
            if let section = HomeScreenSection(rawValue: indexPath.section) {
                switch section {
                case .upcomingMovies:
                    headerView.titleLabel.text = LocalizationKeys.Home.upcomingMoviesTitle.localize()
                case .popularMovies:
                    headerView.titleLabel.text = LocalizationKeys.Home.popularMoviesTitle.localize()
                }
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = HomeScreenSection(rawValue: indexPath.section) else { return .zero }
        
        switch section {
        case .upcomingMovies:
            return CGSize(width: 200, height: 350)
        case .popularMovies:
            return CGSize(width: collectionView.frame.width - 20, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
