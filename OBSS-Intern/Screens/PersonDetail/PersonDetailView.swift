//
//  File.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 6.08.2024.
//

import UIKit
import Kingfisher
import Lottie

class PersonDetailView: UIView {
    
    // MARK: --lazy ui variables
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .normal
        return scrollView
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 0.3
        return imageView
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        view.isHidden = true
        return view
    }()
    
    lazy var personNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return nameLabel
    }()
    
    lazy var birthdayIconTextView: IconTextView = {
        let iconText = IconTextView(imageName: "", text: "", iconColor: .link)
        iconText.translatesAutoresizingMaskIntoConstraints = false
        iconText.setContentCompressionResistancePriority(.required, for: .vertical)
        return iconText
    }()
    
    lazy var placeOfBirthIconTextView: IconTextView = {
        let iconText = IconTextView(imageName: "", text: "", iconColor: .link)
        iconText.translatesAutoresizingMaskIntoConstraints = false
        iconText.setContentCompressionResistancePriority(.required, for: .vertical)
        return iconText
    }()
    
    lazy var personBiographyLabel: UILabel = {
        let biographyLabel = UILabel()
        biographyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        biographyLabel.textColor = .black
        biographyLabel.numberOfLines = 0
        biographyLabel.textAlignment = .left
        biographyLabel.backgroundColor = .clear
        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        biographyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return biographyLabel
    }()
    
    lazy var creditCollectionView: UICollectionView = {
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
    
    lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
    
    lazy var lottieErrorView: LottieAnimationView = {
        let view = LottieView(lottiePath: AppImageConstants.kLottieNotFound).setupAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    // MARK: --public functions
    func applyTheme(_ theme: Theme) {
        let backgroundColor = UIColor.clear.themeBackground(for: theme)
        let textColor = UIColor.clear.themeText(for: theme)
        
        scrollView.backgroundColor = backgroundColor
        uiView.backgroundColor = backgroundColor
        
        // Adjust infoView
        infoView.backgroundColor = backgroundColor
        infoView.layer.shadowColor = theme == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        
        // Adjust text colors
        personNameLabel.textColor = textColor
        personBiographyLabel.textColor = textColor
        
        creditCollectionView.backgroundColor = backgroundColor
        
        personImageView.layer.shadowColor = theme == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        
        loadingView.applyTheme(theme)
        
        creditCollectionView.reloadData()
    }
    
    func loadUIWithData(person: PersonModel) {
        // person image
        guard let image = URL(string: person.profilePath?.getOrginalImage ?? "") else { return }
        personImageView.kf.setImage(with: image)
        
        // person name
        personNameLabel.text = person.name ?? ""
        
        // person biography
        personBiographyLabel.text = person.biography ?? ""
        
        // Birthday, deathday
        let birthday = person.birthday?.toFormattedDateString() ?? ""
        let deathday = person.deathday?.toFormattedDateString() ?? ""
        
        if birthday.isEmpty{
            birthdayIconTextView.setText(LocalizationKeys.Common.unkown.localize(), .darkGray)
        }
        else if deathday.isEmpty {
            birthdayIconTextView.setText("\(birthday)", .darkGray)
        } else {
            birthdayIconTextView.setText("\(birthday) - \(deathday)", .darkGray)
        }
        birthdayIconTextView.setImage(imageName: AppImageConstants.kCalendar)
        birthdayIconTextView.setIconColor(color: .link)
        
        // place of birth
        let placeOfBirth = person.placeOfBirth ?? ""
        if placeOfBirth.isEmpty {
            placeOfBirthIconTextView.setText("\(LocalizationKeys.Common.unkown.localize())", .darkGray)
        }
        else{
            placeOfBirthIconTextView.setText(placeOfBirth, .darkGray)
        }
        placeOfBirthIconTextView.setIconColor(color: .link)
        placeOfBirthIconTextView.setImage(imageName: AppImageConstants.kLocation)
        
        
        // info view animation
        updateInfoViewHideStatus()
        infoView.transform = CGAffineTransform(translationX: 0, y: 400)
        UIView.animate(withDuration: 2, delay: 0.005, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.infoView.transform = .identity
        })
        
        // update layout
        self.infoView.isHidden = false
        self.creditCollectionView.isHidden = false
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.creditCollectionView.reloadData()
    }
    
    func createHorizontalCollectionSectionView() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0)
        
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
    
    func updateCollectionViewHeightConstraint(visibleSectionCount: Int) {
        creditCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(225 * visibleSectionCount)).isActive = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func showErrorView() {
        lottieErrorView.isHidden = false
        lottieErrorView.play()
        bringSubviewToFront(lottieErrorView)
        
        personImageView.isHidden = true
        infoView.isHidden = true
        creditCollectionView.isHidden = true
    }
    
    
    // MARK: --private functions
    
    private func updateInfoViewHideStatus() {
        infoView.isHidden = false
    }

    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(uiView)
        uiView.addSubview(loadingView)
        uiView.addSubview(personImageView)
        uiView.addSubview(infoView)
        uiView.addSubview(lottieErrorView)

        infoView.addSubview(personNameLabel)
        infoView.addSubview(birthdayIconTextView)
        infoView.addSubview(placeOfBirthIconTextView)
        infoView.addSubview(personBiographyLabel)
        infoView.addSubview(creditCollectionView)
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
            
            // Backdrop ImageView constraints
            personImageView.topAnchor.constraint(equalTo: uiView.topAnchor),
            personImageView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            personImageView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            personImageView.heightAnchor.constraint(equalToConstant: 400),
            
            // Info View constraints
            infoView.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: -40),
            infoView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            
            // Person Name constraints
            personNameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            personNameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
            personNameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            
            // Birthday Icon Text constraints
            birthdayIconTextView.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 20),
            birthdayIconTextView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            birthdayIconTextView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            
            // Place of Birth constraints
            placeOfBirthIconTextView.topAnchor.constraint(equalTo: birthdayIconTextView.bottomAnchor, constant: 30),
            placeOfBirthIconTextView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            placeOfBirthIconTextView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            
            // Person Biography constraints
            personBiographyLabel.topAnchor.constraint(equalTo: placeOfBirthIconTextView.bottomAnchor, constant: 20),
            personBiographyLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            personBiographyLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            
            // Credit collection constraints
            creditCollectionView.topAnchor.constraint(equalTo: personBiographyLabel.bottomAnchor, constant: 20),
            creditCollectionView.leadingAnchor.constraint(equalTo: personBiographyLabel.leadingAnchor, constant: 0),
            creditCollectionView.trailingAnchor.constraint(equalTo: personBiographyLabel.trailingAnchor, constant: 0),
            creditCollectionView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20),
        ])
    }
}
