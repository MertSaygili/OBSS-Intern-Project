//
//  CastCollectionViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 5.08.2024.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell, ThemeChangeable {

    // MARK: --lazy
    private var backgroundCardView: UIView!
    private var stackView: UIStackView!
    private var personImageView: UIImageView!
    private var personNameLabel: UILabel!
    private var personAliaseNameLabel: UILabel!

    // MARK: --override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: --required
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: --public
    func configure(item: CreditModel) {
        personImageView.setImage(with: item.profilePath)
        personNameLabel.text = item.name
        personAliaseNameLabel.text = item.character
    }
    
    func applyTheme(_ theme: Theme) {
        if personNameLabel != nil {
            personNameLabel.textColor = UIColor.clear.themeText(for: theme)
        }
        if personAliaseNameLabel != nil {
            personAliaseNameLabel.textColor = UIColor.clear.themeText(for: theme)
        }
        if backgroundCardView != nil {
            backgroundCardView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
        }
    }
    
    // MARK: --private
    private func setupViews() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        personImageView = UIImageView()
        personImageView.contentMode = .scaleAspectFill
        personImageView.layer.cornerRadius = 50
        personImageView.layer.masksToBounds = true
        personImageView.layer.borderColor = UIColor.white.cgColor
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(personImageView)

        personNameLabel = UILabel()
        personNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        personNameLabel.textAlignment = .center
        personNameLabel.numberOfLines = 2
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(personNameLabel)
        
        personAliaseNameLabel = UILabel()
        personAliaseNameLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        personAliaseNameLabel.textColor = .gray
        personAliaseNameLabel.textAlignment = .center
        personAliaseNameLabel.numberOfLines = 2
        personAliaseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(personAliaseNameLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            personImageView.widthAnchor.constraint(equalToConstant: 100),
            personImageView.heightAnchor.constraint(equalToConstant: 100),
            
            personNameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            personAliaseNameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}

