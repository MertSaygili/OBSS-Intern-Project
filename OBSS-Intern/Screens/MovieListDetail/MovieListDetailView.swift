//
//  MovieListDetailView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 13.08.2024.
//

import UIKit

class MovieListDetailView: UIView {
    
    // MARK: --lazy ui variables
    lazy var uiScreenView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        return collectionView
    }()
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: Theme) {
        let backgroundColor = UIColor.clear.themeBackground(for: theme)
        uiScreenView.backgroundColor = backgroundColor
        movieCollectionView.backgroundColor = backgroundColor
        
        for case let cell as ThemeChangeable in movieCollectionView.visibleCells {
            cell.applyTheme(theme)
        }
        
        movieCollectionView.reloadData()
    }
    
    func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(275))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(275))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    func setUpNavigationBar(navigationItem: UINavigationItem, navigationController: UINavigationController, title: String) {
        navigationItem.title = title
        
        let appearance = UINavigationBarAppearance()
        let currentTheme = ThemeManager.shared.currentTheme
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear.themeBackground(for: currentTheme)
        appearance.titleTextAttributes = [.foregroundColor: currentTheme == Theme.dark ? UIColor.white : UIColor.black, .font: UIFont.boldSystemFont(ofSize: 18)]
        appearance.shadowColor = currentTheme == Theme.dark ? UIColor.white : UIColor.black

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: --private functions
    private func setupViews() {
        addSubview(uiScreenView)
        uiScreenView.addSubview(movieCollectionView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // UIView constraints
            uiScreenView.topAnchor.constraint(equalTo: topAnchor),
            uiScreenView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiScreenView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiScreenView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Collection View constraints
            movieCollectionView.topAnchor.constraint(equalTo: uiScreenView.topAnchor, constant: 20),
            movieCollectionView.leadingAnchor.constraint(equalTo: uiScreenView.leadingAnchor, constant: 0),
            movieCollectionView.trailingAnchor.constraint(equalTo: uiScreenView.trailingAnchor, constant: 0),
            movieCollectionView.bottomAnchor.constraint(equalTo: uiScreenView.bottomAnchor, constant: -10)
        ])
    }
}
