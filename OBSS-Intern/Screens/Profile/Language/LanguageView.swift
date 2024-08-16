//
//  LanguageView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

class LanguageView: UIView {

    // MARK: - UI Components
    lazy var languageTableView: UITableView = {
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

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setUpNavigationBar(navigationItem: UINavigationItem, navigationController: UINavigationController) {
        navigationItem.title = LocalizationKeys.Profile.languageTitle.localize()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont.boldSystemFont(ofSize: 18)]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Private Functions
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(languageTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            languageTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            languageTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            languageTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            languageTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
