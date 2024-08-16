//
//  MovieDetailViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 2.08.2024.
//

import UIKit
enum MovieDetailViewSections: Int, CaseIterable {
    case category
    case recommendations
    case cast
    case crew
    case productionCompanies
}

class MovieDetailViewController: BaseViewController {    
    
    // MARK: --variables
    private let movieView: MovieDetailView = MovieDetailView()
    private let movieService: MovieServiceProtocol = MovieService()
    private let castService: CastServiceProtocol = CastService()
    private let favoriteMovieRepository: FavoriteMovieRepositoryProtocol = FavoriteMovieRepository()
    private let customListRepository: CustomListRepositoryProtocol = CustomListRepository()
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    
    private var movieId: Int? = nil
    private var movieName: String = ""
    private var movie: MovieDetailModel? = nil
    private var visibleSections: [MovieDetailViewSections] = []
    private var cast: [CreditModel] = []{
        didSet{loadMovieDetailCollectionView()}
    }
    private var crew: [CreditModel] = [] {
        didSet{loadMovieDetailCollectionView()}
    }
    private var recommendations: [MovieModel] = [] {
        didSet{loadMovieDetailCollectionView()}
    }
    private var categories: [Genre] = []{
        didSet{loadMovieDetailCollectionView()}
    }
    private var productionCompanies: [ProductionCompany] = [] {
        didSet{loadMovieDetailCollectionView()}
    }
    private var movieLoadingState: BaseLoadingState = .loading {
        didSet { loadingStateDidChange() }
    }
    private var creditLoadingState: BaseLoadingState = .loading {
        didSet { loadingStateDidChange() }
    }
    private var recommendationLoadingState: BaseLoadingState = .loading {
        didSet { loadingStateDidChange() }
    }
    private var erroAccur: Bool = false {
        didSet{ errorAccured() }
    }
    
    
    // MARK: --getter and setters:
    var movieID: Int {
        set {
            self.movieId = newValue
        }
        get {
            return self.movieId ?? 0
        }
    }
    
    var movieTitle: String {
        set {
            self.movieName = newValue
        }
        get {
            return self.movieName
        }
    }
    
    // MARK: --override functions
    override func loadView() {
        view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieView.loadingView.startLoading()
        
        fetchMovieDetail()
        fetchMovieCredits()
        fetchMovieRecommendations()
        
        movieView.homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        movieView.bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        
    }
    override func setupUI() {
        setUpNavigationBar()
        setupCollectionView()
        movieView.applyTheme(ThemeManager.shared.currentTheme)
    }
    
    override func updateLocalization() {
        movieView.loadingView.startLoading()
        fetchMovieDetail()
        fetchMovieCredits()
        fetchMovieRecommendations()
        if movie != nil{
            self.movieView.loadMovieDetails(movie: movie!)
        }
        setUpNavigationBar()
    }
    
    override func updateTheme() {
        setupUI()
    }
    
    // MARK: --public functions
    
    // MARK: --private functions
    private func setUpNavigationBar() {
        let theme = ThemeManager.shared.currentTheme

        navigationItem.title = self.movieName

        let backButton = UIBarButtonItem(image: AppImageConstants.arrowLeftImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.themeBackground(for: theme)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white.themeText(for: theme), .font: UIFont.boldSystemFont(ofSize: 18)]
        
        // navigation favorite button
        if !self.erroAccur {
            checkMovieIsFavorite()
        }
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupCollectionView() {
        self.movieView.movieDetailCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        self.movieView.movieDetailCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        self.movieView.movieDetailCollectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.identifier)
        self.movieView.movieDetailCollectionView.register(CreditCollectionViewCell.self, forCellWithReuseIdentifier: CreditCollectionViewCell.identifier)
        self.movieView.movieDetailCollectionView.register(ProductionCompanyCollectionViewCell.self, forCellWithReuseIdentifier: ProductionCompanyCollectionViewCell.identifier)
        self.movieView.movieDetailCollectionView.register(SectionDividerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionDividerHeaderView.identifier)
        
        self.movieView.movieDetailCollectionView.dataSource = self
        self.movieView.movieDetailCollectionView.delegate = self

        self.movieView.movieDetailCollectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionType = self.visibleSections[sectionIndex]
            switch sectionType {
            case .category:
                return self.movieView.createHorizontalCategorySection()
            case .recommendations:
                return self.movieView.createRecommendationsHorizontalSection()
            case .cast:
                return self.movieView.createCastingHorizontalSection()
            case .crew:
                return self.movieView.createCrewHorizontalSection()
            case .productionCompanies:
                return self.movieView.createProductionCompaniesHorizontalSection()
            }
        }
    }
    
    private func fetchMovieDetail() {
        movieService.getMovieById(movieId: self.movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.movie = data
                self.movieLoadingState = .loaded
            case .failure(let error):
                self.movieLoadingState = .error(error)
            }
        }
    }
    
    private func fetchMovieCredits() {
        movieService.getMovieCredits(movieId: self.movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.cast = data.cast ?? []
                self.crew = data.crew ?? []
                self.creditLoadingState = .loaded
            case .failure(let error):
                self.creditLoadingState = .error(error)
            }
        }
    }
    
    private func fetchMovieRecommendations() {
        movieService.getMovieRecommendations(movieId: self.movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.recommendations = data.results ?? []
                self.recommendationLoadingState = .loaded
            case .failure(let error):
                self.recommendationLoadingState = .error(error)
            }
        }
    }
    
    private func loadingStateDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if case .loaded = movieLoadingState, case .loaded = creditLoadingState, case .loaded = recommendationLoadingState {
                loadUI()
            } else if case .error(_) = movieLoadingState {
                self.erroAccur = true
            } else if case .error(_) = creditLoadingState {
                self.erroAccur = true
            } else if case .error(_) = recommendationLoadingState {
                self.erroAccur = true
            }
        }
    }
    
    private func loadUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.movieView.movieDetailCollectionView.reloadData()
            self.checkUserDatas()
            self.loadMovie()
            self.updateVisibleSections()
            self.setupUI()
            self.movieView.loadingView.stopLoading()
        }
    }
    
    private func loadMovieDetailCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.movieView.movieDetailCollectionView.reloadData()
            self?.movieView.movieDetailCollectionView.layoutIfNeeded()
        }
    }
    
    private func loadMovie() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let movie = self.movie else {return}
            
            self.movieView.loadImage(posterPath: movie.posterPath?.getOrginalImage ?? "", backdropPath: movie.backdropPath?.getOrginalImage ?? "")
            self.movieView.loadMovieDetails(movie: movie)
            self.categories = movie.genres ?? []
            self.productionCompanies = movie.productionCompanies ?? []
            self.updateVisibleSections()
        }

    }
    
    private func checkUserDatas() {
        let path = self.movie?.backdropPath ?? ""
        if path.isEmpty {
            erroAccur = true
        }
    }
    
    private func errorAccured() {
        DispatchQueue.main.async { [weak self] in
            self?.movieView.showErrorView()
        }
    }
    
    private func updateVisibleSections() {
        visibleSections.removeAll()
        
        if !categories.isEmpty {
            visibleSections.append(.category)
        }
        
        if !recommendations.isEmpty {
            visibleSections.append(.recommendations)
        }
        
        if !cast.isEmpty {
            visibleSections.append(.cast)
        }
        
        if !crew.isEmpty {
            visibleSections.append(.crew)
        }
        
        if !productionCompanies.isEmpty {
            visibleSections.append(.productionCompanies)
        }
        
        DispatchQueue.main.async {
            self.movieView.movieDetailCollectionView.reloadData()
            self.movieView.updateCollectionViewHeightConstraint(visibleSections: self.visibleSections)
        }
    }
    
    private func navigateToMovieDetail(movieId: Int, movieName: String) {
        guard let navController = self.navigationController else {return}
        
        screenNavigationManager.pushMovieDetail(
            navigationController: navController,
            movieId: movieId,
            movieName: movieName
        )
    }
    
    private func navigateToPersonDetail(personId: Int, personName: String){
        guard let navController = self.navigationController else {return}
        
        screenNavigationManager.pushPersonDetail(
            navigationController: navController,
            personId: personId,
            personName: personName
        )
    }
    
    private func changeFavoriteStatus() {
        guard let movie = self.movie else {return}
        
        let status: Bool = favoriteMovieRepository.isMovieExists(id: movie.id)
        
        if status {
            favoriteMovieRepository.deleteFavoriteMovie(id: movie.id)
        }
        else{
            let entity = MovieEntity()
            entity.movieId = movie.id
            entity.movieName = movie.title
            entity.movieImagePath = movie.posterPath
            
            favoriteMovieRepository.addFavoriteMovie(movie: entity)
        }
        checkMovieIsFavorite()
    }
    
    private func checkMovieIsFavorite() {
        guard let movie = movie else { return }

        let status: Bool = favoriteMovieRepository.isMovieExists(id: movie.id)
        
        let heartImage: UIImage?
        if status {
            heartImage = AppImageConstants.heartFillImage
        } else {
            heartImage = AppImageConstants.heartImage
        }

        let favoriteButton = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(favoriteTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    // MARK: @objc functions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func homeButtonTapped() {
        guard let homepageURL = movie?.homepage, !homepageURL.isEmpty else {
            showToast(message: LocalizationKeys.Error.homePageNotFound.localize())
            return
        }
        
        guard let url = URL(string: homepageURL) else {
            showToast(message: LocalizationKeys.Error.urlNotFound.localize())
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func favoriteTapped() {
        changeFavoriteStatus()
    }
    
    @objc private func bookmarkTapped() {
        var currentList: [CustomListEntity] = []
        
        if let lists = customListRepository.getAllCustomLists() {
            currentList = Array(lists)
        } else {
            currentList = []
        }
        
        // if list is empty, show toast message
        if currentList.isEmpty {
            showToast(message: LocalizationKeys.Error.noCustomList.localize())
            return
        }
        
        // if list is not empty, open shet
        let bookmarkViewController = BookmarkSheetViewController()
        bookmarkViewController.modalPresentationStyle = .pageSheet
        bookmarkViewController.movie = self.movie
        present(bookmarkViewController, animated: true, completion: nil)
    }
}


extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.visibleSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionDividerHeaderView.identifier, for: indexPath) as! SectionDividerHeaderView
            let sectionType = visibleSections[indexPath.section]
            
            switch sectionType{
            case .category:
                headerView.isHidden = true
            case .recommendations:
                headerView.configure(title: LocalizationKeys.MovieDetail.recommendedMovies.localize())
            case .cast:
                headerView.configure(title: LocalizationKeys.MovieDetail.cast.localize())
            case .crew:
                headerView.configure(title: LocalizationKeys.MovieDetail.crew.localize())
            case .productionCompanies:
                headerView.configure(title: LocalizationKeys.MovieDetail.productionCompanies.localize())
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = visibleSections[section]

        switch sectionType{
        case .category:
            return self.categories.count
        case .recommendations:
            return self.recommendations.count
        case .cast:
            return self.cast.count
        case .crew:
            return self.crew.count
        case .productionCompanies:
            return self.productionCompanies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = visibleSections[indexPath.section]
        
        switch sectionType {
        case .category:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(genreName: categories[indexPath.row].name ?? "")
            return cell
        case .recommendations:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.identifier, for: indexPath) as? RecommendedCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(movie: self.recommendations[indexPath.row])
            return cell
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: self.cast[indexPath.row])
            return cell
        case .crew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCollectionViewCell.identifier, for: indexPath) as? CreditCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: self.crew[indexPath.row])
            return cell
        case .productionCompanies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductionCompanyCollectionViewCell.identifier, for: indexPath) as? ProductionCompanyCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(company: self.productionCompanies[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = visibleSections[indexPath.section]
        
        switch sectionType {
        case .recommendations:
            guard let id = self.recommendations[indexPath.row].id else { return }
            navigateToMovieDetail(movieId: id, movieName: self.recommendations[indexPath.row].title ?? "")
        case .cast:
            guard let id = self.cast[indexPath.row].id else { return }
            navigateToPersonDetail(personId: id, personName: self.cast[indexPath.row].originalName ?? "")
        case .crew:
            guard let id = self.crew[indexPath.row].id else { return }
            navigateToPersonDetail(personId: id, personName: self.crew[indexPath.row].originalName ?? "")
        case .category, .productionCompanies:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let sectionType = visibleSections[indexPath.section]
        let theme = ThemeManager.shared.currentTheme
        
        switch sectionType {
        case .recommendations:
            let cell = cell as! RecommendedCollectionViewCell
            cell.configure(movie: self.recommendations[indexPath.row])
            cell.applyTheme(theme)
        case .cast:
            let cell = cell as! CastCollectionViewCell
            cell.configure(item: self.cast[indexPath.row])
            cell.applyTheme(theme)
        case .crew:
            let cell = cell as! CreditCollectionViewCell
            cell.configure(item: self.crew[indexPath.row])
            cell.applyTheme(theme)
        case .category, .productionCompanies:
            break
        }
    }
}


extension MovieDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->
    CGSize {
        let sectionType = visibleSections[indexPath.section]

        switch sectionType{
        case .category:
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = self.categories[indexPath.item].name
            label.sizeToFit()
            return CGSize(width: collectionView.bounds.width - 20, height: 120)
        case .recommendations:
            return CGSize(width: collectionView.bounds.width, height: 250)
        case .cast, .crew, .productionCompanies:
            return CGSize(width: 100, height: 170)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionType = visibleSections[section]

        switch sectionType{
        case .category:
            return 10
        case .recommendations, .cast, .crew, .productionCompanies:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionType = visibleSections[section]

        switch sectionType{
        case .category:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .recommendations, .cast, .crew, .productionCompanies:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        }
    }
}

