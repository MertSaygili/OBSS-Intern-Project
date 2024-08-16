//
//  FavoritesView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//

import UIKit
import Lottie
class FavoritesView: UIView {
    
    // MARK: --lazy ui variables
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var collectionView: UICollectionView = {
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
    
    lazy var lottieErrorView: LottieAnimationView = {
        let view = LottieView(lottiePath: AppImageConstants.kLotteFavoriteNotFound).setupAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
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
        uiView.backgroundColor = backgroundColor
        collectionView.backgroundColor = backgroundColor
        
        for case let cell as ThemeChangeable in collectionView.visibleCells {
            cell.applyTheme(theme)
        }
        
        collectionView.reloadData()
    }
    
    func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    // MARK: --private functions
    private func setupViews() {
        addSubview(uiView)
        addSubview(lottieErrorView)
        uiView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            // UIView constraints
            uiView.topAnchor.constraint(equalTo: topAnchor),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 404 Lottie Error View constraints
            lottieErrorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lottieErrorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lottieErrorView.widthAnchor.constraint(equalToConstant: 300),
            lottieErrorView.heightAnchor.constraint(equalToConstant: 300),
            
            // Collection View constraints
            collectionView.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -10)
        ])
    }
}
