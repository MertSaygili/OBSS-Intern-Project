//
//  MovieDetailView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 2.08.2024.
//

import UIKit
import Kingfisher
import Lottie

class MovieDetailView: UIView {
    
    // MARK: --lazy ui variables
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var backdropMovieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    lazy var movieDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    lazy var rateLanguageRowView: RowDoubleInformationView = {
        let view = RowDoubleInformationView(
            leadingText: "",
            trailingText: "",
            leadingIcon: "",
            trailingIcon: "",
            leadingIconColor: .systemYellow,
            trailingIconColor: .link
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateDurationRowView: RowDoubleInformationView = {
        let view = RowDoubleInformationView(
            leadingText: "",
            trailingText: "",
            leadingIcon: "",
            trailingIcon: "",
            leadingIconColor: .link,
            trailingIconColor: .link
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var budgetRowView: RowDoubleInformationView = {
        let view = RowDoubleInformationView(
            leadingText: "",
            trailingText: "",
            leadingIcon: "",
            trailingIcon: "",
            leadingIconColor: .link,
            trailingIconColor: .link
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .link
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        button.isHidden = true
        button.imageView?.isHidden = true
        return button
    }()
    
    lazy var movieDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10 
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppImageConstants.bookmarkImage, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lottieErrorView: LottieAnimationView = {
        let view = LottieView(lottiePath: AppImageConstants.kLottie404).setupAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: --variables
    var movieDetailCollectionViewHeightConstraint: NSLayoutConstraint?
    var homeIconTapHandler: (() -> Void)?
    
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
    
    // MARK: --public functions
    func loadImage(posterPath: String, backdropPath: String) {
        guard let backdropURL = URL(string: backdropPath) else { return }
        backdropMovieImageView.kf.setImage(with: backdropURL)
    }
    
    func loadMovieDetails(movie: MovieDetailModel) {
        movieNameLabel.text = movie.originalTitle
        movieDescriptionLabel.text = movie.overview
        
        rateLanguageRowView.setAttributes(
            leadingText: "\(String(format: "%.1f", movie.voteAverage ?? 0))/10",
            trailingText: movie.originalLanguage?.uppercased() ?? LocalizationKeys.Common.unkown.localize(),
            leadingIcon: AppImageConstants.kStarFill,
            trailingIcon: AppImageConstants.kGlobe
        )
        dateDurationRowView.setAttributes(
            leadingText: movie.releaseDate?.toFormattedDateString() ?? LocalizationKeys.Common.unkown.localize(),
            trailingText: movie.runtime?.toHoursAndMinutes() ?? LocalizationKeys.Common.unkown.localize(),
            leadingIcon: AppImageConstants.kCalendar,
            trailingIcon: AppImageConstants.kTimer
        )
        budgetRowView.setAttributes(
            leadingText: movie.budget?.moneyConverter() ?? LocalizationKeys.Common.unkown.localize(),
            trailingText: movie.revenue?.moneyConverter() ?? LocalizationKeys.Common.unkown.localize(),
            leadingIcon: AppImageConstants.kDolarSign,
            trailingIcon: AppImageConstants.kFillDolarSign
        )
        
        homeButton.isHidden = false
        homeButton.imageView?.isHidden = false
        homeButton.setTitle(LocalizationKeys.MovieDetail.detailPage.localize(), for: .normal)
        homeButton.setImage(UIImage(systemName: AppImageConstants.kHouseFill), for: .normal)
    }
    
    func applyTheme(_ theme: Theme) {
        let backgroundColor = UIColor.clear.themeBackground(for: theme)
        let textColor = UIColor.clear.themeText(for: theme)
        
        scrollView.backgroundColor = backgroundColor
        uiView.backgroundColor = backgroundColor
        
        infoContainer.backgroundColor = backgroundColor
        infoContainer.layer.shadowColor = theme == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        
        movieNameLabel.textColor = textColor
        movieDescriptionLabel.textColor = theme == .dark ? .lightGray : .darkGray
                
        movieDetailCollectionView.backgroundColor = backgroundColor
        
        loadingView.applyTheme(theme)
                
        backdropMovieImageView.layer.shadowColor = theme == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        
        movieDetailCollectionView.reloadData()
        
        for case let cell as ThemeChangeable in movieDetailCollectionView.visibleCells {
            cell.applyTheme(theme)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func createRecommendationsHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createCastingHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(170)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(20), top: nil, trailing: nil, bottom: nil)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(170)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(30)
           )
           let header = NSCollectionLayoutBoundarySupplementaryItem(
               layoutSize: headerSize,
               elementKind: UICollectionView.elementKindSectionHeader,
               alignment: .top
           )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createCrewHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(20), top: nil, trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(30)
           )
           let header = NSCollectionLayoutBoundarySupplementaryItem(
               layoutSize: headerSize,
               elementKind: UICollectionView.elementKindSectionHeader,
               alignment: .top
           )
        
        section.boundarySupplementaryItems = [header]

        
        return section
    }
    
    func createProductionCompaniesHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(125),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(10), top: nil, trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(125),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(30)
           )
           let header = NSCollectionLayoutBoundarySupplementaryItem(
               layoutSize: headerSize,
               elementKind: UICollectionView.elementKindSectionHeader,
               alignment: .top
           )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createHorizontalCategorySection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(30)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(30)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 30, trailing: 10)
        
        return section
    }
    
    func updateCollectionViewHeightConstraint(visibleSections: [MovieDetailViewSections]) {
        var totalHeight: CGFloat = 0
        
        for section in visibleSections {
            switch section {
            case .category:
                totalHeight += 60
            case .recommendations:
                totalHeight += 280
            case .cast:
                totalHeight += 220
            case .crew:
                totalHeight += 220
            case .productionCompanies:
                totalHeight += 240
            }
        }
        
        DispatchQueue.main.async {
            self.movieDetailCollectionViewHeightConstraint?.constant = totalHeight
            self.layoutIfNeeded()
        }
    }
    
    func showErrorView() {
        lottieErrorView.isHidden = false
        lottieErrorView.play()
        bringSubviewToFront(lottieErrorView)
        
        infoContainer.isHidden = true
        movieDetailCollectionViewHeightConstraint = movieDetailCollectionView.heightAnchor.constraint(equalToConstant: 0)
        movieDetailCollectionView.isHidden = true
        backdropMovieImageView.isHidden = true
    }
    
    // MARK: --private functions
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(uiView)
        scrollView.addSubview(loadingView)
        
        uiView.addSubview(backdropMovieImageView)
        uiView.addSubview(bookmarkButton)
        uiView.addSubview(infoContainer)
        uiView.addSubview(lottieErrorView)

        infoContainer.addSubview(movieNameLabel)
        infoContainer.addSubview(movieDescriptionLabel)
        infoContainer.addSubview(rateLanguageRowView)
        infoContainer.addSubview(dateDurationRowView)
        infoContainer.addSubview(budgetRowView)
        infoContainer.addSubview(homeButton)
        infoContainer.addSubview(movieDetailCollectionView)
        
        movieDetailCollectionViewHeightConstraint = movieDetailCollectionView.heightAnchor.constraint(equalToConstant: 0)
        movieDetailCollectionViewHeightConstraint?.isActive = true
        
        homeButton.isHidden = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // ContainerView constraints
            uiView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            uiView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            uiView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Loading
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 40),
            loadingView.heightAnchor.constraint(equalToConstant: 40),
            
            // 404 Lottie Error View constraints
            lottieErrorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lottieErrorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lottieErrorView.widthAnchor.constraint(equalToConstant: 300),
            lottieErrorView.heightAnchor.constraint(equalToConstant: 300),
            
            // Bookmark
            bookmarkButton.topAnchor.constraint(equalTo: uiView.safeAreaLayoutGuide.topAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -16),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 44),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 44),

            // Backdrop ImageView constraints
            backdropMovieImageView.topAnchor.constraint(equalTo: uiView.topAnchor),
            backdropMovieImageView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            backdropMovieImageView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            backdropMovieImageView.heightAnchor.constraint(equalToConstant: 350),
            
            // Info Container constraints
            infoContainer.topAnchor.constraint(equalTo: backdropMovieImageView.bottomAnchor, constant: -20),
            infoContainer.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            infoContainer.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            infoContainer.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            
            // Movie Name Label constraints
            movieNameLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 20),
            movieNameLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            movieNameLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            // Movie Description Label constraints
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 12),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
        
            // RateLanguageRowView constraints
            rateLanguageRowView.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 20),
            rateLanguageRowView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            rateLanguageRowView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            // DateDurationRowView constraints
            dateDurationRowView.topAnchor.constraint(equalTo: rateLanguageRowView.bottomAnchor, constant: 30),
            dateDurationRowView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            dateDurationRowView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            // BudgetRowView constraints
            budgetRowView.topAnchor.constraint(equalTo: dateDurationRowView.bottomAnchor, constant: 30),
            budgetRowView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            budgetRowView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            // Home button constraints
            homeButton.topAnchor.constraint(equalTo: budgetRowView.bottomAnchor, constant: 20),
            homeButton.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            homeButton.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            // CategoryCollectionView constraints
            movieDetailCollectionView.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 20),
            movieDetailCollectionView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            movieDetailCollectionView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            movieDetailCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            movieDetailCollectionViewHeightConstraint!
        ])
    }
}
