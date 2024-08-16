//
//  MovieListViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import UIKit
import RealmSwift

class MovieListViewController: BaseViewController {
    
    // MARK: --variables
    private let movieListView: MovieListView = MovieListView()
    private let customListRepository: CustomListRepositoryProtocol = CustomListRepository()
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    private var customLists: [CustomListEntity] = [] {
        didSet{loadData()}
    }
    
    private var listNotificationToken: NotificationToken?
    
    // MARK: --required functions && override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieLists()
        setupListObserver()
    }
    
    override func loadView() {
        view = movieListView
    }
    
    override func setupUI() {
        self.setUpNavigationBar()
        self.setTableView()
    }
    
    override func updateLocalization() {
        self.setUpNavigationBar()
    }
    
    override func updateTheme() {
        self.setUpNavigationBar()
    }
    
    deinit {
        listNotificationToken?.invalidate()
    }
    
    // MARK: --public functions
    
    // MARK: --private functions
    private func fetchMovieLists() {
        if let lists = customListRepository.getAllCustomLists() {
            customLists = Array(lists)
        } else {
            customLists = []
        }
    }
    
    private func setUpNavigationBar(){
        guard let navController = self.navigationController else {return}
        
        self.movieListView.setUpNavigationBar(navigationItem: self.navigationItem, navigationController: navController)
    }
    
    private func setTableView(){
        movieListView.movieListTableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        movieListView.movieListTableView.delegate = self
        movieListView.movieListTableView.dataSource = self
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            self.movieListView.movieListTableView.reloadData()
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
            case .error:
                break
            }
        }
    }
    private func handleListChanges(deletions: [Int], insertions: [Int], modifications: [Int]) {
        if !deletions.isEmpty || !insertions.isEmpty || !modifications.isEmpty {
            fetchMovieLists()
        }
    }
    
    private func deleteList(list: CustomListEntity){
        customListRepository.deleteCustomList(customList: list)
    }
    
    private func showDeleteAlert(list: CustomListEntity) {
        let alert = UIAlertController(title: LocalizationKeys.MovieList.deleteListTitle.localize(), message: LocalizationKeys.MovieList.deleteListMessage.localize(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.Common.cancel.localize(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizationKeys.Common.delete.localize(), style: .destructive, handler: { [weak self] _ in
            self?.deleteList(list: list)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    private func pushMovieListDetailViewController(list: CustomListEntity) {
        guard let navController = self.navigationController else {return}
        screenNavigationManager.pushMovieListDetail(navigationController: navController, listId: list._id, listName: list.listName)
    }
}


extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {
           return UITableViewCell()
       }
        
        let list = customLists[indexPath.row]
        cell.configureCell(list: list)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieListTableViewCell else {return}
        
        cell.configureCell(list: customLists[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = customLists[indexPath.row]
        if list.movies.isEmpty {
            self.showToast(message: LocalizationKeys.MovieList.listEmpty.localize())
            return
        }
        
        self.pushMovieListDetailViewController(list: list)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: LocalizationKeys.Common.delete.localize()
        ) { [weak self] (_, _, _) in
            guard let self = self else { return }
            let list = self.customLists[indexPath.row]
            showDeleteAlert(list: list)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
