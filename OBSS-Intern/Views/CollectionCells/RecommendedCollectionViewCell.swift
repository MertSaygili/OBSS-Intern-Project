//
//  RecommendedCollectionViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 5.08.2024.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell, ThemeChangeable {
    
    // MARK: --lazy
    private var backgroundCardView: UIView!
    private var movieImageView: UIImageView!
    private var movieNameLabel: UILabel!

    // MARK: --override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.roundCorners([.topLeft, .topRight], radius: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieNameLabel.text = nil
    }

    // MARK: --required
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: --public
    func configure(movie: MovieModel){
        movieImageView.setImage(with: movie.posterPath)
        movieNameLabel.text = movie.title
    }
    
    func applyTheme(_ theme: Theme) {
        movieNameLabel.textColor = UIColor.clear.themeText(for: theme)
        backgroundCardView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
    }
    
    // MARK: --private
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
        movieImageView = UIImageView()
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.contentMode = .scaleToFill
        movieImageView.clipsToBounds = true
        contentView.addSubview(movieImageView)

        // Label setup
        movieNameLabel = UILabel()
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.textAlignment = .center
        movieNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        movieNameLabel.numberOfLines = 2
        contentView.addSubview(movieNameLabel)

        // Constraints
        NSLayoutConstraint.activate([
           // Background card view constraints
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // movieImageView constraints
            movieImageView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 0.85),

            // titleLabel constraints
            movieNameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 0),
            movieNameLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 5),
            movieNameLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -5),
            movieNameLabel.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 0.15),

        ])
    }
}
