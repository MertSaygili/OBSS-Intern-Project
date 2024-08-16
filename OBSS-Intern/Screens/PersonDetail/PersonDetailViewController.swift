//
//  CastDetailScreen.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 6.08.2024.
//

import UIKit

enum PersonDetailViewSections: Int, CaseIterable{
    case cast
    case crew
}

class PersonDetailViewController: BaseViewController{

    // MARK: --variables
    private let personView: PersonDetailView = PersonDetailView()
    private let castService: CastServiceProtocol = CastService()
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    
    private var personID: Int = 0
    private var personNAME: String = ""
    private var personModel: PersonModel? = nil
    private var visibleSections: [PersonDetailViewSections] = []
    
    private var personCastMovies: [MovieDetailModel] = [] {
        didSet{loadCredits()}
    }
    private var personCrewMovies: [MovieDetailModel] = [] {
        didSet{loadCredits()}
    }
    private var personLoadingState: BaseLoadingState = .loading {
        didSet { loadingStateDidChange() }
    }
    private var personCombinedCreditsLoadingState: BaseLoadingState = .loading {
        didSet { loadingStateDidChange() }
    }
    private var erroAccur: Bool = false {
        didSet{ errorAccured() }
    }
    
    // MARK: --getter and setters:
    var personId: Int {
        set {
            self.personID = newValue
        }
        get {
            return self.personID
        }
    }
    
    var personName: String {
        set {
            self.personNAME = newValue
        }
        get{
            return self.personNAME
        }
    }
    
    // MARK: --override functions
    override func loadView() {
        view = personView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.personView.loadingView.startLoading()
        self.fetchPersonDetail()
        self.fetchPersonCombinedCredit()
    }
    
    override func setupUI() {
        self.setUpNavigationBar()
        self.setupCollectionView()
        self.personView.applyTheme(ThemeManager.shared.currentTheme)
    }
    
    override func updateLocalization() {
        self.personView.loadingView.startLoading()
        self.fetchPersonDetail()
        self.fetchPersonCombinedCredit()
    }
    
    override func updateTheme() {
        setupUI()
        setupCollectionView()
        self.personView.applyTheme(ThemeManager.shared.currentTheme)
    }
    
    // MARK: --public functions
    
    // MARK: --private functions
    private func setupCollectionView() {
        self.personView.creditCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        self.personView.creditCollectionView.register(SectionDividerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionDividerHeaderView.identifier)
        
        self.personView.creditCollectionView.dataSource = self
        self.personView.creditCollectionView.delegate = self

        self.personView.creditCollectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = PersonDetailViewSections(rawValue: sectionIndex)
            switch section {
            case .cast, .crew:
                return self.personView.createHorizontalCollectionSectionView()
            case .none:
                return nil
            }
        }
    }
    
    private func fetchPersonDetail() {
        castService.getPersonDetail(personId: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                personModel = data
                self.personLoadingState = .loaded
            case .failure(let error):
                self.personLoadingState = .error(error)
            }
        }
    }
    
    private func fetchPersonCombinedCredit() {
        castService.getPersonCombinedCredits(personId: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                personCastMovies = data.cast ?? []
                personCrewMovies = data.crew ?? []
                self.personCombinedCreditsLoadingState = .loaded
            case .failure(let error):
                self.personCombinedCreditsLoadingState = .error(error)
            }
        }
    }
    
    private func loadUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadPerson()
            self.loadCredits()
            self.checkUserDatas()
            self.setupUI()
            self.updateVisibleSections()
            self.personView.loadingView.stopLoading()
            self.loadCredits()
            self.loadViewIfNeeded()
        }
    }
    
    private func loadingStateDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
    
            if case .loaded = personLoadingState, case .loaded = personCombinedCreditsLoadingState{
                loadUI()
            } else if case .error(_) = personLoadingState {
                self.erroAccur = true
            } else if case .error(_) = personCombinedCreditsLoadingState {
                self.erroAccur = true
            }
        }
    }
    
    private func errorAccured() {
        DispatchQueue.main.async { [weak self] in
            self?.personView.showErrorView()
        }
    }
    
    private func checkUserDatas() {
        let path = personModel?.profilePath ?? ""
        if path.isEmpty {
            erroAccur = true
        }
    }
    
    private func loadPerson() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let person = self.personModel else {return}
            self.personView.loadUIWithData(person: person)
        }
    }
    
    private func loadCredits() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.personView.creditCollectionView.reloadData()
        }
    }
    
    private func updateVisibleSections() {
        visibleSections.removeAll()
        
        if !(personCastMovies.isEmpty) {
            visibleSections.append(.cast)
        }
        
        if !(personCrewMovies.isEmpty) {
            visibleSections.append(.crew)
        }
        
        loadCredits()
        self.personView.updateCollectionViewHeightConstraint(visibleSectionCount: self.visibleSections.count)
    }
    
    private func setUpNavigationBar() {
        let theme = ThemeManager.shared.currentTheme
        
        navigationItem.title = self.personName

        let backButton = UIBarButtonItem(image: AppImageConstants.arrowLeftImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.themeBackground(for: theme)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white.themeText(for: theme), .font: UIFont.boldSystemFont(ofSize: 18)]

        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func navigateToMovieDetail(movieId: Int, movieName: String) {
        guard let navController = self.navigationController else {return}
        
        screenNavigationManager.pushMovieDetail(
            navigationController: navController,
            movieId: movieId,
            movieName: movieName
        )
    }
    
    // MARK: -- @objc functions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PersonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.visibleSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionDividerHeaderView.identifier, for: indexPath) as! SectionDividerHeaderView
            let sectionType = visibleSections[indexPath.section]
            
            switch sectionType {
            case .cast:
                headerView.configure(title: LocalizationKeys.PersonDetail.cast.localize())
            case .crew:
                headerView.configure(title: LocalizationKeys.PersonDetail.crew.localize())
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = visibleSections[section]

        switch sectionType{
        case .cast:
            return self.personCastMovies.count
        case .crew:
            return self.personCrewMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = visibleSections[indexPath.section]
        
        switch sectionType {
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(movie: self.personCastMovies[indexPath.row])
            return cell
        case .crew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(movie: self.personCrewMovies[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let section = PersonDetailViewSections(rawValue: indexPath.section) else { return false}

        switch section{
        case .cast:
            guard let id = self.personCastMovies[indexPath.row].id else {return false}
            navigateToMovieDetail(movieId: id, movieName: self.personCastMovies[indexPath.row].title ?? "")
        case .crew:
            guard let id = self.personCrewMovies[indexPath.row].id else {return false}
            navigateToMovieDetail(movieId: id, movieName: self.personCrewMovies[indexPath.row].title ?? "")
        }
    
        return false
    }
}
