//
//  BookmarkSheetViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 13.08.2024.
//

import UIKit
import RealmSwift

class BookmarkSheetViewController: UIViewController {

    // MARK: -- lazy variables
    private lazy var listTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        return tv
    }()
    
    private lazy var createListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKeys.Profile.createList.localize(), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK --variables
    private let customListRepository: CustomListRepositoryProtocol = CustomListRepository()
    
    private var listNotificationToken: NotificationToken?
    private var customLists: [CustomListEntity] = [] {
        didSet{loadList()}
    }
    
    var movie: MovieDetailModel?
    
    // MARK: --override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        getLists()
        setupViews()
        setupConstraints()
        setupListObserver()
    }
    
    deinit {
        listNotificationToken?.invalidate()
    }

    // MARK: --private functions
    private func setupViews() {
        let theme = ThemeManager.shared.currentTheme
        view.backgroundColor = UIColor.clear.themeBackground(for: theme)
        view.addSubview(createListButton)
        view.addSubview(listTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            createListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            createListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            createListButton.heightAnchor.constraint(equalToConstant: 44),
            
            listTableView.topAnchor.constraint(equalTo: createListButton.bottomAnchor, constant: 15),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    private func getLists() {
        if let lists = customListRepository.getAllCustomLists() {
            customLists = Array(lists)
        } else {
            customLists = []
        }
    }
    
    private func isMovieBookMarkedInList(list: CustomListEntity) -> Bool {
        if list.movies.contains(where: {$0.movieId == self.movie?.id}) {
            return true
        }
        return false
    }
    
    private func addMovieToList(list: CustomListEntity) {
        let isMarked = isMovieBookMarkedInList(list: list)
        // if movie already added then remove it
        if isMarked == true {
            customListRepository.removeMovieFromList(listId: list._id, movieId: self.movie?.id ?? 0)
            return
        }
        
        // if movie not added then add it
        let movie = MovieEntity()
        movie.movieId = self.movie?.id ?? 0
        movie.movieName = self.movie?.title ?? ""
        movie.movieImagePath = self.movie?.posterPath ?? ""
        
        customListRepository.addMovieToList(listId: list._id, movie: movie)
    }
    
    private func loadList() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    private func setupListObserver() {
        let realm = StorageManager.shared.getRealmInstance
        let customUserList = realm.objects(CustomUserList.self).first
        
        listNotificationToken = customUserList?.list.observe { [weak self] changes in
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, let insertions, let modifications):
                self?.handleListChanges(deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(_):
                break
            }
        }
    }
    
    private func handleListChanges(deletions: [Int], insertions: [Int], modifications: [Int]) {
        if !deletions.isEmpty || !insertions.isEmpty || !modifications.isEmpty {
            getLists()
            loadList()
        }
    }
    
    private func createNewList(listName: String) {
        customListRepository.createCustomList(listName: listName)
    }
    
    // MARK: --@objc functions
    @objc private func createListButtonTapped() {
        let dialog = CreateNewListDialog()
        dialog.show(in: self) { [weak self] text in
            self?.createNewList(listName: text)
        }
    }
}

extension BookmarkSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {return UITableViewCell()}
        
        let list = customLists[indexPath.row]
        let isMarked = isMovieBookMarkedInList(list: list)
        cell.configureCell(list: list, isMovieBookmarked: isMarked, showRightIcon: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = customLists[indexPath.row]
        addMovieToList(list: list)
    }
}
