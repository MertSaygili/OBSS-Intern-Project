//
//  MovieView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import UIKit

class MovieListView: UIView {

    // MARK: --lazy variables
    lazy var movieListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        return tableView
    }()
    
    // MARK: --required functions && override functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    // MARK: --public function
    func setUpNavigationBar(navigationItem: UINavigationItem, navigationController: UINavigationController) {
       let theme = ThemeManager.shared.currentTheme
       
        navigationItem.title = LocalizationKeys.MovieList.movieList.localize()
       
       let appearance = UINavigationBarAppearance()
       appearance.configureWithOpaqueBackground()
       appearance.backgroundColor = UIColor.white.themeBackground(for: theme)
       appearance.titleTextAttributes = [.foregroundColor: UIColor.white.themeText(for: theme), .font: UIFont.boldSystemFont(ofSize: 18)]

       
       navigationController.navigationBar.standardAppearance = appearance
       navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: --private functions
    private func setupViews(){
        backgroundColor = .systemBackground
        addSubview(movieListTableView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            movieListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            movieListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
