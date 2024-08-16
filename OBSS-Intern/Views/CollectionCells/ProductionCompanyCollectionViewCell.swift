//
//  ProductionCompanyCollectionViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 7.08.2024.
//

import UIKit

class ProductionCompanyCollectionViewCell: UICollectionViewCell, ThemeChangeable {
    
    // MARK: --variables
    private var backgroundCardView: UIView!
    private var companyImageView: UIImageView!
    private var companyNameLabel: UILabel!

    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
        companyImageView.roundCorners([.topLeft, .topRight], radius: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        companyImageView.image = nil
        companyNameLabel.text = nil
    }
    
    // MARK: --public functions
    func configure(company: ProductionCompany) {
        companyImageView.setImage(with: company.logoPath)
        companyNameLabel.text = company.name
    }
    
    func applyTheme(_ theme: Theme) {
        companyNameLabel.textColor = UIColor.clear.themeText(for: theme)
        backgroundCardView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
    }
    
    // MARK: --private function
    private func setupViews() {
        // Background card view setup
        backgroundCardView = UIView()
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.backgroundColor = .white
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.shadowColor = UIColor.black.cgColor
        backgroundCardView.layer.shadowOpacity = 0.2
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundCardView.insetsLayoutMarginsFromSafeArea = false
        backgroundCardView.layer.shadowRadius = 4
        contentView.addSubview(backgroundCardView)
        
        // ImageView setup
        companyImageView = UIImageView()
        companyImageView.translatesAutoresizingMaskIntoConstraints = false
        companyImageView.contentMode = .scaleAspectFit
        companyImageView.clipsToBounds = true
        contentView.addSubview(companyImageView)
        
        // Label setup
        companyNameLabel = UILabel()
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.textAlignment = .center
        companyNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        companyNameLabel.numberOfLines = 2
        contentView.addSubview(companyNameLabel)

        // Constraints
        NSLayoutConstraint.activate([
           // Background card view constraints
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundCardView.heightAnchor.constraint(equalToConstant: 150),
            backgroundCardView.widthAnchor.constraint(equalToConstant: 125),
            
            // movieImageView constraints
            companyImageView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor),
            companyImageView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor),
            companyImageView.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor),
            companyImageView.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 0.8),
            
            // titleLabel constraints
            companyNameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 0),
            companyNameLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 5),
            companyNameLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -5),
            companyNameLabel.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 0.2),
        ])
    }
}
